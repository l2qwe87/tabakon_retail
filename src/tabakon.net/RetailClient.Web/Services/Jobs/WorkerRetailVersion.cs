using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerRetailVersion : WorkerT
    {
        public WorkerRetailVersion(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
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
                    return (alwaysSaveResult)
                        ? new[] { e.Message }
                        : new string[0];
                }
            });
        }
    }
}
