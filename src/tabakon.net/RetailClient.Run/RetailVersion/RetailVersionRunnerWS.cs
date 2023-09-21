using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;
using System.Threading.Tasks;

namespace RetailClient.Run.RetailVersion {
    public class RetailVersionRunnerWS : GenericWS<RequestToSync, RequestResult, Tabakon.Entity.RetailVersion> {
        public RetailVersionRunnerWS(
            IServiceProvider serviceProvider, 
            RetailVersionRunnerDB genericDB, 
            ILogger<RetailVersionRunnerWS> logger) : base(serviceProvider, genericDB, logger) {
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
                return  (await ws.GetVersionAsync());
            }
            catch (Exception e) {
                _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                return null;
            }
        }
    }
}
