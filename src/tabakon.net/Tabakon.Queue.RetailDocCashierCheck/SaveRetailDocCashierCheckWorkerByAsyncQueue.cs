using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Queue.Contracts;

namespace Tabakon.Queue.RetailDocCashierCheck {
    public class SaveRetailDocCashierCheckWorkerByAsyncQueue : AbstractWorkerByAsyncQueue<SaveRetailDocCashierCheck> {
        private readonly IServiceProvider _serviceProvider;
        public SaveRetailDocCashierCheckWorkerByAsyncQueue(
            IServiceProvider serviceProvider
            ) {
            _serviceProvider = serviceProvider;

            this.Start();
        }

        protected override async Task Do(SaveRetailDocCashierCheck item) {
            try {
                var hasChanges = false;
                var entity = new Tabakon.Entity.RetailDocCashierCheck();
                entity.PopulateData(item.RetailEndpoint);
                entity.PopulateData(item.JSON);
                //entity.Pop
                var ctx = _serviceProvider.GetService<TabakonDBContext>();
                var dbset = ctx.RetailDocCashierCheck;
                var existentEntity = dbset.Where(e => 
                    e.RetailEndpointIdentity == item.RetailEndpoint.RetailEndpointIdentity &&
                    e.DocRef == entity.DocRef
                    ).Select(e => e.JsonData);

                if(existentEntity == null) {
                    await dbset.AddAsync(entity);
                }

                if (hasChanges) { 
                    await ctx.SaveChangesAsync();
                }
            }
            catch (Exception e) {
                var logger = _serviceProvider.GetService<ILogger<SaveRetailDocCashierCheckWorkerByAsyncQueue>>();
                logger.LogError(e, $"{item.RetailEndpoint.RetailEndpointHost} \n{e.Message}");
            }
            throw new NotImplementedException();
        }
    }
}
