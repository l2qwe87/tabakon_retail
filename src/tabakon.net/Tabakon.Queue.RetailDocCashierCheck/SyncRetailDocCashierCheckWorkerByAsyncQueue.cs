using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using RetailClient;
using System;
using System.Threading.Tasks;
using Tabakon.Queue.Contracts;

namespace Tabakon.Queue.RetailDocCashierCheck {
    public class SyncRetailDocCashierCheckWorkerByAsyncQueue : AbstractWorkerByAsyncQueue<SyncRetailDocCashierCheck> {

        private readonly IServiceProvider _serviceProvider;
        private readonly SaveRetailDocCashierCheckWorkerByAsyncQueue _saveRetailDocCashierCheckWorkerByAsyncQueue;
        public SyncRetailDocCashierCheckWorkerByAsyncQueue(
            IServiceProvider serviceProvider,
            SaveRetailDocCashierCheckWorkerByAsyncQueue saveRetailDocCashierCheckWorkerByAsyncQueue
            ) {

            _serviceProvider = serviceProvider;
            _saveRetailDocCashierCheckWorkerByAsyncQueue = saveRetailDocCashierCheckWorkerByAsyncQueue;

            this.Start();

            Task.Run(async () => {
                while (true) {
                    await Task.Delay(TimeSpan.FromSeconds(5));
                    LoggingStatus();
                }
            });

        }
        protected override async Task Do(SyncRetailDocCashierCheck item) {

            try {
                var ws = new RetailWSClient(item.RetailEndpoint.RetailEndpointHost, item.RetailEndpoint.RetailEndpointUrl);
                var json = await ws.GetRetailDocCashierCheck(item.Date);
                await _saveRetailDocCashierCheckWorkerByAsyncQueue.Add(new SaveRetailDocCashierCheck {
                    Date = item.Date,
                    RetailEndpoint = item.RetailEndpoint,
                    JSON = json
                });
            }
            catch (Exception e) {
                var logger = _serviceProvider.GetService<ILogger<SyncRetailDocCashierCheckWorkerByAsyncQueue>>();
                logger.LogError(e, $"{item.RetailEndpoint.RetailEndpointHost} \n{e.Message}");
            }
        }

        protected override void LoggingStatus() {
            using (var scope = _serviceProvider.CreateScope()) {
                var serviceProvider = scope.ServiceProvider;
                var logger = _serviceProvider.GetService<ILogger<SaveRetailDocCashierCheckWorkerByAsyncQueue>>();
                logger.LogInformation(this.GetStatus());
            }
        }
    }
}
