using RetailClient.Run.Generic;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using Tabakon.Entity;

namespace RetailClient.Run.RetailVersion {

    public class RetailVersionRunner : GenericRunner<RequestToSync, RequestResult, Tabakon.Entity.RetailVersion> {
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
