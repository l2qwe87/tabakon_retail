using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services.Jobs;

namespace RetailClient.Worker
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IJobService _jobService;

        public Worker(
            IJobService jobService,
            ILogger<Worker> logger
            )
        {
            _logger = logger;
            _jobService = jobService;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _jobService.AddTask<WorkerRetailDocCashierCheck>(TimeSpan.FromHours(4));
            _jobService.AddTask<WorkerRetailDocSelesReport>(TimeSpan.FromMinutes(20));
            _jobService.AddTask<WorkerRetailVersion>(TimeSpan.FromMinutes(25));
            _jobService.AddTask<WorkerRetailExtConfiguration>(TimeSpan.FromMinutes(25));
            _jobService.AddTask<WorkerPing>(TimeSpan.FromMinutes(15));
            _jobService.AddTask<WorkerRetailGetStoreBalance>(TimeSpan.FromMinutes(60));


            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                await Task.Delay(1000, stoppingToken);
            }
        }
    }
}
