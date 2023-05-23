using RetailClient.Run.Generic;
using RetailClient.Web.Contracts;
using System.Collections.Generic;
using System;
using Tabakon.Entity;

namespace RetailClient.Run.RetailPing {
    public class RetailPingRunner : GenericRunner<RequestToSync, RequestResult, Tabakon.Entity.RetailPing> {
        public RetailPingRunner(
            IServiceProvider serviceProvider,
            IRetailEndpointsRepo retailEndpointsRepo,
            RetailPingRunnerWS genericWS,
            RetailPingRunnerDB genericDB)
            : base(serviceProvider, retailEndpointsRepo, genericWS, genericDB) {
        }

        protected override IEnumerable<RequestToSync> BuildRequests(RetailEndpoint item) {
            return new[] { new RequestToSync { RetailEndpoint = item } };
        }
    }
}
