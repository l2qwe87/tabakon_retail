using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Queue.Contracts;
using Tabakon.Queue.RetailDocCashierCheck;

namespace RetailClient.Run.RetailPing {
    public class RetailPingerDB : AbstractWorkerByAsyncQueue<RetailPingResult> {
        private readonly IServiceProvider _serviceProvider;

        public RetailPingerDB(
            IServiceProvider serviceProvider
            ) {

            _serviceProvider = serviceProvider;

            this.Start();
            Task.Run(async () => {
                while (true) {
                    await Task.Delay(TimeSpan.FromSeconds(5));
                    LoggingStatus();
                }
            });
        }
        protected override async Task Do(RetailPingResult item) {
            using (var scope = _serviceProvider.CreateScope()) {
                var serviceProvider = scope.ServiceProvider;
                var logger = serviceProvider.GetService<ILogger<SaveRetailDocCashierCheckWorkerByAsyncQueue>>();

                try {
                    var hasChanges = false;
                    var ctx = serviceProvider.GetService<TabakonDBContext>();

                    var dbset = ctx.RetailPing;
                    var existentEntity = dbset.Where(e =>
                        e.RetailEndpointIdentity == item.RetailEndpoint.RetailEndpointIdentity
                        ).Select(e => e)
                        .FirstOrDefault();

                    if (existentEntity == null) {
                        hasChanges = true;

                        var entity = new Tabakon.Entity.RetailPing();
                        entity.PopulateData(item.RetailEndpoint);
                        entity.PopulateData(item.JSON);

                        await dbset.AddAsync(entity);
                    }
                    else {
                        if (existentEntity.JsonData != item.JSON) {
                            hasChanges = true;
                            existentEntity.PopulateData(item.JSON);
                        };
                    }

                    if (hasChanges) {
                        await ctx.SaveChangesAsync();
                    }
                }
                catch (Exception e) {
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