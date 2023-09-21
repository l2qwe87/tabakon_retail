using RetailClient.Run.Generic;
using System;
using Microsoft.Extensions.Logging;

namespace RetailClient.Run.RetailDocCashierCheck
{
    public class RetailDocCashierCheckRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailDocCashierCheck> {
        protected override bool AlwaysUpdate => false;
        public RetailDocCashierCheckRunnerDB(
            IServiceProvider serviceProvider,
            ILogger<RetailDocCashierCheckRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
