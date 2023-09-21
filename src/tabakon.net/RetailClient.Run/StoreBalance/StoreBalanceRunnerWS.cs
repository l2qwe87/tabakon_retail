using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;
using System.Threading.Tasks;

namespace RetailClient.Run.StoreBalance {
    public class StoreBalanceRunnerWS : GenericWS<RequestToSync, RequestResult, Tabakon.Entity.RetailGetStoreBalance> {
        public StoreBalanceRunnerWS(
            IServiceProvider serviceProvider,
            StoreBalanceRunnerDB genericDB,
            ILogger<StoreBalanceRunnerWS> logger) : base(serviceProvider, genericDB, logger) {
        }

        protected override RequestResult BuildRequestReuslt(RequestToSync item, string json) {
            return new RequestResult {
                RetailEndpoint = item.RetailEndpoint,
                JSON = json
            };
        }

        protected override async Task<string> InvokeWS(RequestToSync item) {
            var endpoint = item.RetailEndpoint;
            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            try {
                return (await ws.GetStoreBalanceAsync());
            }
            catch (Exception e) {
                _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                return null;
            }
        }
    }
}
