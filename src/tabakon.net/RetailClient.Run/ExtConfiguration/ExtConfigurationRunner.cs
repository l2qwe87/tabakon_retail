using RetailClient.Run.Generic;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using Tabakon.Entity;

namespace RetailClient.Run.ExtConfiguration {

    public class ExtConfigurationRunner : GenericRunner<RequestToSync, RequestResult, Tabakon.Entity.RetailExtConfiguration> {
        public ExtConfigurationRunner(
            IServiceProvider serviceProvider, 
            IRetailEndpointsRepo retailEndpointsRepo,
            ExtConfigurationRunnerWS genericWS,
            ExtConfigurationRunnerDB genericDB) 
            : base(serviceProvider, retailEndpointsRepo, genericWS, genericDB) {
        }

        protected override IEnumerable<RequestToSync> BuildRequests(RetailEndpoint item) {
            return new[] { new RequestToSync { RetailEndpoint = item } };
        }
    }
}
