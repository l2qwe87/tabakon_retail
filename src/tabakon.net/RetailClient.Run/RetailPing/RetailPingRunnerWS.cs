using RetailClient.Run.Generic;
using System;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace RetailClient.Run.RetailPing {
    public class RetailPingRunnerWS : GenericWS<RequestToSync, RequestResult, Tabakon.Entity.RetailPing> {
        public RetailPingRunnerWS(
            IServiceProvider serviceProvider,
            RetailPingRunnerDB genericDB,
            ILogger<RetailPingRunnerWS> logger) : base(serviceProvider, genericDB, logger) {
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
                return (await ws.PingAsync()).ToString();
            }
            catch (Exception e) {
                _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                return null;
            }
        }
    }
}
