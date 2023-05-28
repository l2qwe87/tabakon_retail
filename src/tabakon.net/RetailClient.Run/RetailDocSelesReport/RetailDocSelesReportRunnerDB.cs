using RetailClient.Run.Generic;
using System;
using Microsoft.Extensions.Logging;

namespace RetailClient.Run.RetailDocSelesReport
{
    public class RetailDocSelesReportRunnerDB : GenericDB<RequestResult, Tabakon.Entity.RetailDocSelesReport_NEW> {
        protected override bool AlwaysUpdate => false;
        public RetailDocSelesReportRunnerDB(
            IServiceProvider serviceProvider,
            ILogger<RetailDocSelesReportRunnerDB> logger) : base(serviceProvider, logger) {
        }
    }
}
