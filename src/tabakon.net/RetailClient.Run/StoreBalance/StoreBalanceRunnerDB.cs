using Microsoft.Extensions.Logging;
using RetailClient.Run.Generic;
using System;

namespace RetailClient.Run.StoreBalance {
    public class StoreBalanceRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailGetStoreBalance> {
        protected override bool AlwaysUpdate => true;
        public StoreBalanceRunnerDB(
            IServiceProvider serviceProvider,
            ILogger<StoreBalanceRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
