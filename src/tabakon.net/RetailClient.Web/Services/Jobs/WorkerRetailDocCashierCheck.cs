﻿using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerRetailDocCashierCheck : WorkerT
    {
        public WorkerRetailDocCashierCheck(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider, Func<RetailEndpoint, bool> predicat = null)
        {
            var alwaysSaveResult = false;
            var result = await DoWorkAsync<RetailDocCashierCheck>(alwaysSaveResult, async (endpoint) =>
            {
                var arr = new List<string>();
                var dateBegin = DateTime.Now.Date.AddDays(-50);
#if RELEASE
                dateBegin = DateTime.Now.Date.AddDays(-5);
#endif
                while (dateBegin < DateTime.Now)
                {
                    var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                    try
                    {
                        var json = await ws.GetRetailDocCashierCheck(dateBegin);
                        var jArray = JArray.Parse(json);
                        var docs = jArray.Select(e => e.ToString()).ToList();
                        arr.AddRange(docs);
                        //var _logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport>>();
                        //_logger.LogWarning(JsonConvert.SerializeObject(docs));
                    }
                    catch (Exception e)
                    {
                        //arr.Add(e.Message);
                        var _logger = serviceProvider.GetService<ILogger<WorkerRetailDocCashierCheck>>();
                        _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                    }
                    dateBegin = dateBegin.AddDays(1);
                }

                //Console.Out.WriteLine($"WorkerRetailDocSelesReport : {endpoint.RetailEndpointName} : {arr.Count()}");
                var logger = serviceProvider.GetService<ILogger<WorkerRetailDocCashierCheck>>();

                logger.LogInformation($"WorkerRetailDocCashierCheck : {endpoint.RetailEndpointName} : {arr.Count()}");

                return arr;
            }, predicat);
        }
    }
}