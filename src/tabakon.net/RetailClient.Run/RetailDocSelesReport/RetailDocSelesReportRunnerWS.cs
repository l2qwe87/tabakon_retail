using RetailClient.Run.Generic;
using System;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace RetailClient.Run.RetailDocSelesReport
{
    public partial class RetailDocSelesReportRunnerWS : GenericWS<RetailDocSelesReportRequestToSync, RequestResult, Tabakon.Entity.RetailDocSelesReport_NEW> {
        public RetailDocSelesReportRunnerWS(
            IServiceProvider serviceProvider,
            RetailDocSelesReportRunnerDB genericDB,
            ILogger<RetailDocSelesReportRunnerWS> logger) : base(serviceProvider, genericDB, logger) {
        }

        protected override RequestResult BuildRequestReuslt(RetailDocSelesReportRequestToSync item, string json) {
            return new RequestResult {
                RetailEndpoint = item.RetailEndpoint,
                JSON = json
            };
        }

        protected override async Task<string> InvokeWS(RetailDocSelesReportRequestToSync item) {
            var endpoint = item.RetailEndpoint;
            var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
            try {
                return (await ws.GetRetailDocSelesReport_NEW(item.Date)).ToString();
            }
            catch (Exception e) {
                _logger.LogError(e, $"{endpoint.RetailEndpointHost} \n{e.Message}");
                return null;
            }
        }
    }
}
