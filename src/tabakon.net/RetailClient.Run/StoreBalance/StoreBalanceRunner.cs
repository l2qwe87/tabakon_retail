using RetailClient.Run.Generic;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using Tabakon.Entity;

namespace RetailClient.Run.StoreBalance {

    public class StoreBalanceRunner : GenericRunner<RequestToSync, RequestResult, Tabakon.Entity.RetailGetStoreBalance> {
        public StoreBalanceRunner(
            IServiceProvider serviceProvider, 
            IRetailEndpointsRepo retailEndpointsRepo,
            StoreBalanceRunnerWS genericWS,
            StoreBalanceRunnerDB genericDB) 
            : base(serviceProvider, retailEndpointsRepo, genericWS, genericDB) {
        }

        protected override IEnumerable<RequestToSync> BuildRequests(RetailEndpoint item) {
            return new[] { new RequestToSync { RetailEndpoint = item } };
        }
    }
}
