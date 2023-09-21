using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;

namespace RetailClient.Run.RetailVersion {
    public class RetailVersionRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailVersion> {
        protected override bool AlwaysUpdate => true;
        public RetailVersionRunnerDB(
            IServiceProvider serviceProvider, 
            ILogger<RetailVersionRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
