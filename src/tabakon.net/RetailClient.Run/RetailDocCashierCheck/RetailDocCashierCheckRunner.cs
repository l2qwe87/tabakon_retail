using Microsoft.Extensions.DependencyInjection;
using RetailClient.Run.Generic;
using RetailClient.Web.Contracts;
using System.Collections.Generic;
using System;
using Tabakon.Entity;
using static RetailClient.Run.RetailDocCashierCheck.RetailDocCashierCheckRunnerWS;
using Microsoft.Extensions.Configuration;
using System.Linq;

namespace RetailClient.Run.RetailDocCashierCheck {
    public class RetailDocCashierCheckRunner : GenericRunner<RetailDocCashierCheckRequestToSync, RequestResult, Tabakon.Entity.RetailDocCashierCheck> {
        public RetailDocCashierCheckRunner(
            IServiceProvider serviceProvider,
            IRetailEndpointsRepo retailEndpointsRepo,
            RetailDocCashierCheckRunnerWS genericWS,
            RetailDocCashierCheckRunnerDB genericDB)
            : base(serviceProvider, retailEndpointsRepo, genericWS, genericDB) {
        }

        protected override IEnumerable<RetailDocCashierCheckRequestToSync> BuildRequests(RetailEndpoint item) {

            var dateDepth = _serviceProvider.GetRequiredService<IConfiguration>().GetValue<int>("Runner:DateDepth");

            DateTime begin = DateTime.Now.AddDays(-1 * dateDepth);
            DateTime end = DateTime.Now;
            List < DateTime > dates = new List<DateTime>();
            for (DateTime date = begin; date <= end; date = date.AddDays(1)) {
                dates.Add(date);
            }

            return dates.Select(date => new RetailDocCashierCheckRequestToSync {
                RetailEndpoint = item,
                Date = date
            });
        }
    }
}
