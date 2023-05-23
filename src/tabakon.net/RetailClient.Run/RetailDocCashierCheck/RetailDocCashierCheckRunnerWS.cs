using RetailClient.Run.Generic;
using System;
using Microsoft.Extensions.Logging;
using RetailClient.Run.RetailPing;
using System.Threading.Tasks;

namespace RetailClient.Run.RetailDocCashierCheck {
    public class RetailDocCashierCheckRunnerWS : GenericWS<RetailDocCashierCheckRequestToSync, RequestResult, Tabakon.Entity.RetailDocCashierCheck> {
        public RetailDocCashierCheckRunnerWS(
            IServiceProvider serviceProvider,
            RetailDocCashierCheckRunnerDB genericDB,
            ILogger<RetailPingRunnerWS> logger) : base(serviceProvider, genericDB, logger) {
        }

        protected override RequestResult BuildRequestReuslt(RetailDocCashierCheckRequestToSync item, string json) {
            return new RequestResult {
                RetailEndpoint = item.RetailEndpoint,
                JSON = json
            };
        }

        protected override async Task<string> InvokeWS(RetailDocCashierCheckRequestToSync item) {
            var endpoint = item.RetailEndpoint;
            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            try {
                return (await ws.GetRetailDocCashierCheck(item.Date)).ToString();
            }
            catch (Exception e) {
                _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                return null;
            }
        }

        public class RetailDocCashierCheckRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailDocCashierCheck> {
            protected override bool AlwaysUpdate => false;
            public RetailDocCashierCheckRunnerDB(
                IServiceProvider serviceProvider,
                ILogger<RetailPingRunnerDB> logger) : base(serviceProvider, logger) {
            }
        }
    }
}
