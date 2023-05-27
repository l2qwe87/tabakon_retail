using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;
using Tabakon.Queue.Contracts;

namespace RetailClient.Run.Generic {
    public abstract class GenericDB<TRequest, TEntity> : AbstractWorkerByAsyncQueue<TRequest>
        where TRequest : RequestResult
        where TEntity : AbstractCacheEntity {

        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger _logger;

        public GenericDB(
            IServiceProvider serviceProvider,
            ILogger logger) {


            _serviceProvider = serviceProvider;
            _logger = logger;

            this.Start();
            Task.Run(async () => {
                while (true) {
                    await Task.Delay(TimeSpan.FromSeconds(5));
                    LoggingStatus();
                }
            });
        }

        protected override int WorkerCount => 16;

        protected virtual bool AlwaysUpdate => false;
        protected override async Task Do(TRequest item) {
            using (var scope = _serviceProvider.CreateScope()) {
                var serviceProvider = scope.ServiceProvider;

                try {

                    if (String.IsNullOrEmpty(item.JSON)) {
                        return;
                    }

                    var hasChanges = false;
                    var ctx = serviceProvider.GetService<TabakonDBContext>();

                    var entity = Activator.CreateInstance<TEntity>();
                    entity.PopulateData(item.RetailEndpoint);
                    entity.PopulateData(item.JSON);

                    var dbset = ctx.Set<TEntity>();
                    var existentEntityQuery = dbset.Where(e =>
                        e.RetailEndpointIdentity == item.RetailEndpoint.RetailEndpointIdentity
                    );

                    if (entity is AbstractDocEntity) {
                        existentEntityQuery = existentEntityQuery.Where(e => 
                            (e as AbstractDocEntity).DocRef == (entity as AbstractDocEntity).DocRef
                        );
                    }

                    var existentEntity = existentEntityQuery.Select(e => e)
                        .FirstOrDefault();

                    if (existentEntity == null) {
                        hasChanges = true;

                        await dbset.AddAsync(entity);
                    }
                    else {
                        if (!AlwaysUpdate || existentEntity.JsonData != item.JSON) {
                            hasChanges = true;
                            existentEntity.PopulateData(item.JSON);
                        };
                    }

                    if (hasChanges) {
                        await ctx.SaveChangesAsync();
                    }
                }
                catch (Exception e) {
                    _logger.LogError(e, $"{item.RetailEndpoint.RetailEndpointHost} \n{e.Message}");
                }
            }
        }
        protected override void LoggingStatus() {
            _logger.LogInformation(this.GetStatus());
        }
    }
}
