using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerRetailDocSelesReport_NEW : WorkerT
    {
        public WorkerRetailDocSelesReport_NEW(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider, Func<RetailEndpoint, bool> predicat = null)
        {
            var alwaysSaveResult = false;
            await DoWorkAsync<RetailDocSelesReport_NEW>(alwaysSaveResult, async (endpoint) =>
            {
                var arr = new List<string>();
                var dateBegin = DateTime.Now.Date.AddDays(-50);
#if RELEASE
                dateBegin = DateTime.Now.Date.AddDays(-7);
#endif
                while (dateBegin < DateTime.Now)
                {
                    var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                    try
                    {
                        var json = await ws.GetRetailDocSelesReport_NEW(dateBegin);
                        var jArray = JArray.Parse(json);
                        var docs = jArray.Select(e => e.ToString()).ToList();
                        arr.AddRange(docs);
                    }
                    catch (Exception e)
                    {
                        var _logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport_NEW>>();
                        _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                    }
                    dateBegin = dateBegin.AddDays(1);
                }

                var logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport_NEW>>();

                logger.LogInformation($"WorkerRetailDocSelesReport : {endpoint.RetailEndpointName} : {arr.Count()}");

                return arr;
            }, predicat);
        }
    }
}
