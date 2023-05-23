using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;

namespace RetailClient.Run.RetailVersion {
    public class RetailVersionRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailVersion> {
        public RetailVersionRunnerDB(
            IServiceProvider serviceProvider, 
            ILogger<RetailVersionRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
