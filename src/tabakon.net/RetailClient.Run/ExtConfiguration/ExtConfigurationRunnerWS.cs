using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;
using System.Threading.Tasks;

namespace RetailClient.Run.ExtConfiguration {
    public class ExtConfigurationRunnerWS : GenericWS<RequestToSync, RequestResult, Tabakon.Entity.RetailExtConfiguration> {
        public ExtConfigurationRunnerWS(
            IServiceProvider serviceProvider, 
            ExtConfigurationRunnerDB genericDB, 
            ILogger<ExtConfigurationRunnerWS> logger) : base(serviceProvider, genericDB, logger) {
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
                return  (await ws.GetExtConfigurationAsync());
            }
            catch (Exception e) {
                _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                return null;
            }
        }
    }
}
