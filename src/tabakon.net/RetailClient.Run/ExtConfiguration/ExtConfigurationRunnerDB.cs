using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;

namespace RetailClient.Run.ExtConfiguration {
    public class ExtConfigurationRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailExtConfiguration> {
        protected override bool AlwaysUpdate => true;
        public ExtConfigurationRunnerDB(
            IServiceProvider serviceProvider, 
            ILogger<ExtConfigurationRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
