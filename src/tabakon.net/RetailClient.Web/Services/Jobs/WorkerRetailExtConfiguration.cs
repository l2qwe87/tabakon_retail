using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerRetailExtConfiguration : WorkerT
    {
        public WorkerRetailExtConfiguration(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider, Func<RetailEndpoint, bool> predicat = null)
        {
            var alwaysSaveResult = false;
            var result = await DoWorkAsync<RetailExtConfiguration>(alwaysSaveResult, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                try
                {
                    return new[] { (await ws.GetExtConfigurationAsync()) };
                }
                catch (Exception e)
                {
                    var _logger = serviceProvider.GetService<ILogger<RetailExtConfiguration>>();
                    _logger.LogError($"{endpoint.RetailEndpointHost} \n{e.Message}", e);

                    return (alwaysSaveResult)
                        ? new[] { e.Message }
                        : new string[0];
                }
            }, predicat);
        }
    }
}
