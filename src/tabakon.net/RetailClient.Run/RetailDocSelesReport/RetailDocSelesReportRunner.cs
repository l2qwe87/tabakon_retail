using Microsoft.Extensions.DependencyInjection;
using RetailClient.Run.Generic;
using RetailClient.Web.Contracts;
using System.Collections.Generic;
using System;
using Tabakon.Entity;
using Microsoft.Extensions.Configuration;
using System.Linq;

namespace RetailClient.Run.RetailDocSelesReport {
    public class RetailDocSelesReportRunner : GenericRunner<RetailDocSelesReportRequestToSync, RequestResult, Tabakon.Entity.RetailDocSelesReport_NEW> {
        public RetailDocSelesReportRunner(
            IServiceProvider serviceProvider,
            IRetailEndpointsRepo retailEndpointsRepo,
            RetailDocSelesReportRunnerWS genericWS,
            RetailDocSelesReportRunnerDB genericDB)
            : base(serviceProvider, retailEndpointsRepo, genericWS, genericDB) {
        }

        protected override IEnumerable<RetailDocSelesReportRequestToSync> BuildRequests(RetailEndpoint item) {

            var dateDepth = _serviceProvider.GetRequiredService<IConfiguration>().GetValue<int>("Runner:DateDepth");

            DateTime begin = DateTime.Now.AddDays(-1 * dateDepth);
            DateTime end = DateTime.Now;
            List < DateTime > dates = new List<DateTime>();
            for (DateTime date = begin; date <= end; date = date.AddDays(1)) {
                dates.Add(date);
            }

            return dates.Select(date => new RetailDocSelesReportRequestToSync {
                RetailEndpoint = item,
                Date = date
            });
        }
    }
}
