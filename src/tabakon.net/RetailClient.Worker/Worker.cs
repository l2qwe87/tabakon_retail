using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services.Jobs;
using Tabakon.Queue.RetailDocCashierCheck;

namespace RetailClient.Worker
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly JobConfig _jobConfig;
        private readonly IJobService _jobService;

        public Worker(
            IJobService jobService,
            JobConfig jobConfig,
            ILogger<Worker> logger,
            IServiceProvider serviceProvider
            )
        {
            _logger = logger;
            _jobConfig = jobConfig;
            _jobService = jobService;

            var saveRetailDocCashierCheckWorkerByAsyncQueue = serviceProvider.GetService(typeof(SaveRetailDocCashierCheckWorkerByAsyncQueue)) as SaveRetailDocCashierCheckWorkerByAsyncQueue;
            saveRetailDocCashierCheckWorkerByAsyncQueue.Start();
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            //Version
            if(_jobConfig.Version)
            {
                _jobService.AddTask<WorkerRetailVersion>(TimeSpan.FromMinutes(25));
                _jobService.AddTask<WorkerRetailExtConfiguration>(TimeSpan.FromMinutes(25));
            }
            //Ping
            if (_jobConfig.Ping)
            {
                _jobService.AddTask<WorkerPing>(TimeSpan.FromMinutes(15));
            }
            //StoreBalance
            if (_jobConfig.StoreBalance)
            {
                _jobService.AddTask<WorkerRetailGetStoreBalance>(TimeSpan.FromMinutes(60));
            }
            //SelesReport
            if (_jobConfig.SelesReport)
            {
                _jobService.AddTask<WorkerRetailDocSelesReport>(TimeSpan.FromMinutes(20));
                _jobService.AddTask<WorkerRetailDocSelesReport_NEW>(TimeSpan.FromMinutes(20));
            }
            //CashierCheck
            if (_jobConfig.CashierCheck)
            {
                ////_jobService.AddTask<WorkerRetailDocCashierCheck_1Day>(TimeSpan.FromMinutes(20));
                _jobService.AddTask<WorkerRetailDocCashierCheck_1Day>(TimeSpan.FromHours(4));
                _jobService.AddTask<WorkerRetailDocCashierCheck_2Day>(TimeSpan.FromDays(1));
                _jobService.AddTask<WorkerRetailDocCashierCheck_5Day>(TimeSpan.FromDays(2));
                _jobService.AddTask<WorkerRetailDocCashierCheck_30Day>(TimeSpan.FromDays(10));
                _jobService.AddTask<WorkerRetailDocCashierCheck_90Day>(TimeSpan.FromDays(30));
                
            }
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                await Task.Delay(100000, stoppingToken);
            }
        }
    }
}
