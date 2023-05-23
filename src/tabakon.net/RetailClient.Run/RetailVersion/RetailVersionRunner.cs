using RetailClient.Run.Generic;
using RetailClient.Run.RetailPing;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services.Jobs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tabakon.Entity;
using Tabakon.Queue.Contracts;
using Tabakon.Queue.RetailDocCashierCheck;

namespace RetailClient.Run.RetailVersion {

    public class RetailVersionRunner : Generic.GenericRunner<RequestToSync, RequestResult, Tabakon.Entity.RetailVersion> {
        public RetailVersionRunner(
            IServiceProvider serviceProvider, 
            IRetailEndpointsRepo retailEndpointsRepo,
            RetailVersionRunnerWS genericWS,
            RetailVersionRunnerDB genericDB) 
            : base(serviceProvider, retailEndpointsRepo, genericWS, genericDB) {
        }

        protected override IEnumerable<RequestToSync> BuildRequests(RetailEndpoint item) {
            return new[] { new RequestToSync { RetailEndpoint = item } };
        }
    }
}
