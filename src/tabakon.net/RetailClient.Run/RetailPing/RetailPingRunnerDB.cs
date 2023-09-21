using RetailClient.Run.Generic;
using System;
using Microsoft.Extensions.Logging;

namespace RetailClient.Run.RetailPing {
    public class RetailPingRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailPing> {
        protected override bool AlwaysUpdate => false;
        public RetailPingRunnerDB(
            IServiceProvider serviceProvider,
            ILogger<RetailPingRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
