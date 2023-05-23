using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using Tabakon.Queue.Contracts;
using Tabakon.Queue.RetailDocCashierCheck;

namespace RetailClient.Run.RetailPing {
    public class RetailPingerWS : AbstractWorkerByAsyncQueue<RetailPingRequestToSync> {
        private readonly IServiceProvider _serviceProvider;
        private readonly RetailPingerDB _retailPingerDB;

        public RetailPingerWS(
            IServiceProvider serviceProvider,
            RetailPingerDB retailPingerDB
            ) {

            _serviceProvider = serviceProvider;
            _retailPingerDB = retailPingerDB;

            this.Start();
            Task.Run(async () => { 
                while (true) {
                    await Task.Delay(TimeSpan.FromSeconds(5));
                    LoggingStatus();
                } 
            });
        }

        protected override int WorkerCount => 16;

        protected override async Task Do(RetailPingRequestToSync item) {
            var ws = new RetailWSClient(item.RetailEndpoint.RetailEndpointHost, item.RetailEndpoint.RetailEndpointUrl);
            string pingResult = "";
            try {
                pingResult = (await ws.PingAsync()).ToString();
                await _retailPingerDB.Add(new RetailPingResult {
                    RetailEndpoint = item.RetailEndpoint,
                    JSON = pingResult
                }); ;
            }
            catch (Exception e) {
                using (var scope = _serviceProvider.CreateScope()) {
                    var serviceProvider = scope.ServiceProvider;
                    var logger = _serviceProvider.GetService<ILogger<SaveRetailDocCashierCheckWorkerByAsyncQueue>>();
                    logger.LogError(e, $"{item.RetailEndpoint.RetailEndpointHost} \n{e.Message}");
                }
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
