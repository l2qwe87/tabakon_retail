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
            var endpoints = await retailEndpointsRepo.GetRetailEndpointsAsync();
            var versions = await retailEndpointsRepo.GetRetailEndpointsVersionAsync();
            var extConfigurations = await retailEndpointsRepo.GetRetailExtConfigurationAsync();


            return endpoints.Select(e => new RetailEndpointDto(e) { 
                ExtData = new RetailEndpointExtData { 
                    RetailVersion = versions.FirstOrDefault(s => s.RetailEndpointIdentity == e.RetailEndpointIdentity),
                    RetailExtConfiguration = extConfigurations.FirstOrDefault(s => s.RetailEndpointIdentity == e.RetailEndpointIdentity)
                }
            });
        }

        [HttpGet("RetailVersion/{retailEndpointIdentity}")]
        public async Task<RetailVersion> GetRetailVersion(string retailEndpointIdentity) 
        {
            var workerRetailVersion = serviceProvider.GetService<WorkerRetailVersion>();
            await workerRetailVersion.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var data = await retailEndpointsRepo.GetRetailEndpointsVersionAsync();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return data.FirstOrDefault();
        }

        [HttpGet("RetailExtConfiguration/{retailEndpointIdentity}")]
        public async Task<RetailExtConfiguration> GetRetailExtConfiguration(string retailEndpointIdentity)
        {
            var workerRetailVersion = serviceProvider.GetService<WorkerRetailExtConfiguration>();
            await workerRetailVersion.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var data = await retailEndpointsRepo.GetRetailExtConfigurationAsync();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return data.FirstOrDefault();
        }

        [HttpPost("RetailExtConfiguration/{retailEndpointIdentity}")]
        public async Task<RetailExtConfiguration> SetRetailExtConfiguration(string retailEndpointIdentity, [FromBody] string extConfiguration)
        {
            var retailEndpointsRepo = serviceProvider.GetRequiredService<IRetailEndpointsRepo>();
            var endpoint = (await retailEndpointsRepo.GetRetailEndpointsAsync()).FirstOrDefault(e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            await ws.SetExtConfigurationAsync(extConfiguration);


            var workerRetailVersion = serviceProvider.GetService<WorkerRetailExtConfiguration>();
            await workerRetailVersion.RunAsync(serviceProvider, e => e.RetailEndpointIdentity == retailEndpointIdentity);

            var data = await retailEndpointsRepo.GetRetailExtConfigurationAsync();
            data = data.Where(v => v.RetailEndpointIdentity == retailEndpointIdentity);
            return data.FirstOrDefault();
        }
    }
}
