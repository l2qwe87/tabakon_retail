﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Linq.Expressions;

namespace RetailClient.Web.Services.Jobs
{
    public class WorkerRetailGetStoreBalance : WorkerT
    {
        public WorkerRetailGetStoreBalance(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider, Expression<Func<RetailEndpoint, bool>> predicat = null)
        {
            var alwaysSaveResult = false;
            await DoWorkAsync<RetailGetStoreBalance>(alwaysSaveResult, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                try
                {
                    return new[] { (await ws.GetStoreBalanceAsync()) };
                }
                catch (Exception e)
                {
                    var _logger = serviceProvider.GetService<ILogger<RetailGetStoreBalance>>();
                    _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");

                    return (alwaysSaveResult)
                        ? new[] { e.Message }
                        : new string[0];
                }
            }, predicat);
        }
    }
}
