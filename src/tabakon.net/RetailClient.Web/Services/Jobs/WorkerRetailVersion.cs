using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerRetailVersion : WorkerT
    {
        public WorkerRetailVersion(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider, Func<RetailEndpoint, bool> predicat = null)
        {
            var alwaysSaveResult = false;
            var result = await DoWorkAsync<RetailVersion>(alwaysSaveResult, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                try
                {
                    return new[] { (await ws.GetVersionAsync()) };
                }
                catch (Exception e)
                {
                    var _logger = serviceProvider.GetService<ILogger<WorkerRetailVersion>>();
                    _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");

                    return (alwaysSaveResult)
                        ? new[] { e.Message }
                        : new string[0];
                }
            }, predicat);
        }
    }
}
