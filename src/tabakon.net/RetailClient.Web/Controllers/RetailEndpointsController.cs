using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using RetailClient;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services.Jobs;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClientTests.Controllers
{

    public class RetailEndpointExtData
    {
        public RetailVersion RetailVersion { get; set; }
        public RetailExtConfiguration RetailExtConfiguration { get; set; }
    }
    public class RetailEndpointDto //: RetailEndpoint 
    {
        private readonly RetailEndpoint endpoint;
        public RetailEndpointDto(RetailEndpoint endpoint) {
            this.endpoint = endpoint;
        }

        public string RetailEndpointIdentity => endpoint.RetailEndpointIdentity;
        public string RetailEndpointName => endpoint.RetailEndpointName;
        public string RetailEndpointHost => endpoint.RetailEndpointHost;
        public string RetailEndpointUrl => endpoint.RetailEndpointUrl;
        public bool MarkAsDeleted => endpoint.MarkAsDeleted;
        public RetailEndpointExtData ExtData { get;set;}
}

    [ApiController]
    [Route("api/[controller]")]
    public class RetailEndpointsController : ControllerBase
    {
        private readonly IRetailEndpointsRepo retailEndpointsRepo;
        private readonly IServiceProvider serviceProvider;


        public RetailEndpointsController(
            IRetailEndpointsRepo retailEndpointsRepo,
            IServiceProvider serviceProvider
            )
        {
            this.retailEndpointsRepo = retailEndpointsRepo;
            this.serviceProvider = serviceProvider;
        }
        [HttpGet]
        public async Task<IEnumerable<RetailEndpointDto>> Get()
        {
            var endpoints = await retailEndpointsRepo.GetRetailEndpoints().AsNoTracking().ToListAsync();
            var versions = await retailEndpointsRepo.GetRetailEndpointsVersion().AsNoTracking().ToListAsync();
            var extConfigurations = await retailEndpointsRepo.GetRetailExtConfiguration().AsNoTracking().ToListAsync();


            return endpoints.Select(e => new RetailEndpointDto(e) {
                ExtData = new RetailEndpointExtData {
                    RetailVersion = versions.FirstOrDefault(s => s.RetailEndpointIdentity == e.RetailEndpointIdentity),
                    RetailExtConfiguration = extConfigurations.FirstOrDefault(s => s.RetailEndpointIdentity == e.RetailEndpointIdentity)
                }
            });
        }

        [HttpGet("UpdateData/{retailEndpointIdentity}")]
        public async Task<RetailVersion> UpdateData(string retailEndpointIdentity)
        {

            var jobs = new[] {
                typeof(WorkerRetailVersion), 
                typeof(WorkerRetailDocCashierCheck_2Day),
                typeof(WorkerRetailExtConfiguration)
            };
            foreach (var jobType in jobs)
            {
                var worker = serviceProvider.GetService(jobType) as ITask;
                await worker.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);
            }

            var data = retailEndpointsRepo.GetRetailEndpointsVersion();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return await data
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        [HttpGet("RetailVersion/{retailEndpointIdentity}")]
        public async Task<RetailVersion> GetRetailVersion(string retailEndpointIdentity)
        {
            var workerRetailVersion = serviceProvider.GetService<WorkerRetailExtConfiguration>();
            await workerRetailVersion.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var data = retailEndpointsRepo.GetRetailEndpointsVersion();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return await data
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        [HttpGet("RetailExtConfiguration/{retailEndpointIdentity}")]
        public async Task<RetailExtConfiguration> GetRetailExtConfiguration(string retailEndpointIdentity)
        {
            var workerRetailVersion = serviceProvider.GetService<WorkerRetailExtConfiguration>();
            await workerRetailVersion.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var data = retailEndpointsRepo.GetRetailExtConfiguration();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return await data
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        [HttpGet("RetailExtConfiguration/{retailEndpointIdentity}/{extConfiguration}")]
        public async Task<RetailExtConfiguration> SetRetailExtConfiguration(string retailEndpointIdentity, string extConfiguration)
        {
            var retailEndpointsRepo = serviceProvider.GetRequiredService<IRetailEndpointsRepo>();
            var endpoint = await retailEndpointsRepo.GetRetailEndpoints()
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            await ws.SetExtConfigurationAsync(extConfiguration);


            var workerRetailVersion = serviceProvider.GetService<WorkerRetailExtConfiguration>();
            await workerRetailVersion.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var data = retailEndpointsRepo.GetRetailExtConfiguration();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return await data.AsNoTracking().FirstOrDefaultAsync();
        }

        [HttpGet("Run_apply_cfe/{retailEndpointIdentity}")]
        public async Task Run_apply_cfe(string retailEndpointIdentity)
        {
            var retailEndpointsRepo = serviceProvider.GetRequiredService<IRetailEndpointsRepo>();
            var endpoint = await retailEndpointsRepo.GetRetailEndpoints().FirstOrDefaultAsync(e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            await ws.Run_apply_cfe();
        }

        [HttpGet("Run_exRetailOle/{retailEndpointIdentity}")]
        public async Task Run_exRetailOle(string retailEndpointIdentity)
        {
            var retailEndpointsRepo = serviceProvider.GetRequiredService<IRetailEndpointsRepo>();
            var endpoint = await retailEndpointsRepo.GetRetailEndpoints()
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            await ws.Run_exRetailOle();
        }
    }
}
