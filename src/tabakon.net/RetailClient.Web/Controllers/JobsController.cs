using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Tabakon.DAL;
using Tabakon.Entity;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration.EnvironmentVariables;

namespace RetailClient.Web.Controllers {
    [ApiController]
    [Route("[controller]")]
    public class JobsController : ControllerBase {

        //private readonly TabakonDBContext ctx;
        private readonly IServiceProvider serviceProvider;
        public JobsController(
            //TabakonDBContext ctx,
            IServiceProvider serviceProvider
            ) {
            this.serviceProvider = serviceProvider;
        }


        [HttpGet("GetRetailDocSelesReport")]
        public string GetRetailDocSelesReport() {
#if DEBUG
            var _host = "127.0.0.1";
            var ws = new RetailWSClient(_host, "http://localhost:8080/retail_1");
            var _date = DateTime.Parse("2020/07/31");
#else
            var _host = "10.101.0.50";
            var ws = new RetailWSClient(_host, "http://10.101.0.50/retail");
            var _date = DateTime.Now.AddDays(-1);
#endif


            var wsResult = ws.GetRetailDocSelesReport(_date).Result;

            try {
                var ctx = serviceProvider.GetRequiredService<TabakonDBContext>();
                var dbset = ctx.Set<RetailDocSelesReport>();

                var endpoint = ctx.RetailEndpoint.FirstOrDefault(e => e.RetailEndpointHost == _host);

                AbstractCacheEntity entity = Activator.CreateInstance<RetailDocSelesReport>()
                            .PopulateData(endpoint)
                            .PopulateData(wsResult);

                entity = dbset.FirstOrDefault(entity.IsEquals<RetailDocSelesReport>().Compile());
                if (entity == null) {
                    entity = Activator.CreateInstance<RetailDocSelesReport>()
                        .PopulateData(endpoint)
                        .PopulateData(wsResult);

                    dbset.Add(entity as RetailDocSelesReport);
                }

                string jsonData = entity.JsonData;
                entity.LastCheck = DateTime.Now;
                entity.PopulateData(wsResult);

                ctx.SaveChanges();
            }
            catch (Exception e) {
                wsResult = wsResult + "\n" + e.Message;
            }

            return wsResult;
        }

        [HttpGet("Ping")]
        public async Task<IEnumerable<RetailPing>> Ping() {
            var result = await DoWorkAsync<RetailPing>(true, async (endpoint) => {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                return await ws.PingAsync();
            });
            return result;
        }


        [HttpGet("Version")]
        public async Task<IEnumerable<RetailVersion>> Version() {
            var result = await DoWorkAsync<RetailVersion>(false, async (endpoint) => {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                return await ws.GetVersionAsync();
            });
            return result;
        }

        private async Task<IEnumerable<T>> DoWorkAsync<T>(bool alwaysSaveResult, Func<RetailEndpoint, Task<object>> func) where T : AbstractCacheEntity {
            List<RetailEndpoint> endpoints = null;
            using (var scope = serviceProvider.CreateScope()) {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                endpoints = await ctx.RetailEndpoint.Select(r => r).AsNoTracking().ToListAsync();
            }

            var tasks = endpoints.Select(async endpoint => {
                return await JobAsync<T>(alwaysSaveResult, endpoint, func);
            });
            await Task.WhenAll(tasks);

            using (var scope = serviceProvider.CreateScope()) {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var result = await ctx.Set<T>().Select(r => r).AsNoTracking().ToListAsync();
                return result;
            }
        }

        private async Task<T> JobAsync<T>(bool alwaysSaveResult, RetailEndpoint endpoint, Func<RetailEndpoint, Task<object>> func) where T : AbstractCacheEntity {
            using (var scope = serviceProvider.CreateScope()) {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var dbset = ctx.Set<T>();
                var entity = dbset.FirstOrDefault(r => r.RetailEndpointIdentity == endpoint.RetailEndpointIdentity);
                if (entity == null) {
                    entity = Activator.CreateInstance<T>();
                    //entity.RetailEndpoint = endpoint;
                    entity.RetailEndpointIdentity = endpoint.RetailEndpointIdentity;

                    await dbset.AddAsync(entity);
                }

                string jsonData = entity.JsonData;
                try {
                    var wsResult = await func(endpoint);
                    entity.LastCheck = DateTime.Now;
                    entity.JsonData = JsonConvert.SerializeObject(wsResult);
                }
                catch (Exception e) {
                    if (alwaysSaveResult || entity.JsonData == null) {
                        entity.JsonData = e.Message;
                        entity.LastCheck = DateTime.Now;
                    }

                }

                await ctx.SaveChangesAsync();
                return entity;
            }
        }

    }
}
