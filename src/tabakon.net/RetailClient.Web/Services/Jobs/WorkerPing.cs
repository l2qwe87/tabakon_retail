using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerPing : WorkerT
    {
        public WorkerPing(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
        {
            var alwaysSaveResult = true;
            var result = await DoWorkAsync<RetailPing>(alwaysSaveResult, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                try
                {
                    return new[] { (await ws.PingAsync()).ToString() };
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
