using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using RetailClient;
using Tabakon.DAL;
using Tabakon.Entity;
using Microsoft.Extensions.DependencyInjection;

namespace RetailClientTests.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class JobsController : ControllerBase
    {

        //private readonly TabakonDBContext ctx;
        private readonly IServiceProvider serviceProvider;
        public JobsController(
            //TabakonDBContext ctx,
            IServiceProvider serviceProvider
            )
        {
            this.serviceProvider = serviceProvider;
        }
        [HttpGet("Ping")]
        public async Task<IEnumerable<RetailPing>> Ping()
        {
            List<RetailEndpoint> endpoints = null;
            using(var scope = serviceProvider.CreateScope() )
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                endpoints = await ctx.RetailEndpoint.Select(r => r).ToListAsync();
            }

            foreach(var endpoint in endpoints)
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                object wsResult = null;
                try{
                    wsResult = await ws.PingAsync();
                }catch(Exception e)
                {
                    wsResult = e.Message;
                }

                using(var scope = serviceProvider.CreateScope() )
                {
                    var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                    var entity = ctx.RetailPing.FirstOrDefault(r => r.RetailEndpointIdentity == endpoint.RetailEndpointIdentity);
                    if(entity == null){
                        entity = new RetailPing{
                            //RetailEndpoint = endpoint,
                            RetailEndpointIdentity = endpoint.RetailEndpointIdentity
                        };
                        await ctx.RetailPing.AddAsync(entity);
                    }

                    entity.LastCheck = DateTime.Now;
                    entity.JsonData = JsonConvert.SerializeObject(wsResult);
                    await ctx.SaveChangesAsync();
                }

            }

            using(var scope = serviceProvider.CreateScope() )
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var result = await ctx.RetailPing.Select(r => r).ToListAsync();
                return result;
            }            
        }


        [HttpGet("Version")]
        public async Task<IEnumerable<RetailVersion>> Version()
        {
            List<RetailEndpoint> endpoints = null;
            using(var scope = serviceProvider.CreateScope() )
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                endpoints = await ctx.RetailEndpoint.Select(r => r).ToListAsync();
            }

            foreach(var endpoint in endpoints)
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                object wsResult = null;
                try{
                    wsResult = await ws.GetVersionAsync();
                }catch(Exception e)
                {
                    wsResult = e.Message;
                }

                using(var scope = serviceProvider.CreateScope() )
                {
                    var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                    var entity = ctx.RetailVersion.FirstOrDefault(r => r.RetailEndpointIdentity == endpoint.RetailEndpointIdentity);
                    if(entity == null){
                        entity = new RetailVersion{
                            //RetailEndpoint = endpoint,
                            RetailEndpointIdentity = endpoint.RetailEndpointIdentity
                        };
                        await ctx.RetailVersion.AddAsync(entity);
                    }

                    entity.LastCheck = DateTime.Now;
                    entity.JsonData = JsonConvert.SerializeObject(wsResult);
                    await ctx.SaveChangesAsync();
                }

            }

            using(var scope = serviceProvider.CreateScope() )
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var result = await ctx.RetailVersion.Select(r => r).ToListAsync();
                return result;
            }    
        }

    }
}
