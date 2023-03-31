using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
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
           
            using (var scope = _serviceProvider.CreateScope())
            {
                var serviceProvider = scope.ServiceProvider;
                var logger = serviceProvider.GetService<ILogger<SaveRetailDocCashierCheckWorkerByAsyncQueue>>();

                try
                {
                    var hasChanges = false;
                    var ctx = serviceProvider.GetService<TabakonDBContext>();
                    var jArray = JArray.Parse(item.JSON);
                    var docsJson = jArray.Select(e => e.ToString()).ToList();
                    foreach (var docJson in docsJson)
                    {
                        var entity = new Tabakon.Entity.RetailDocCashierCheck();
                        entity.PopulateData(item.RetailEndpoint);
                        entity.PopulateData(docJson);

                        var dbset = ctx.RetailDocCashierCheck;
                        var existentEntity = dbset.Where(e =>
                            e.RetailEndpointIdentity == item.RetailEndpoint.RetailEndpointIdentity &&
                            e.DocRef == entity.DocRef
                            ).Select(e => e.JsonData)
                            .FirstOrDefault();

                        if (existentEntity == null)
                        {
                            await dbset.AddAsync(entity);
                        }
                    }

                    if (hasChanges)
                    {
                        await ctx.SaveChangesAsync();
                    }
                }
                catch (Exception e)
                {
                    
                    logger.LogError(e, $"{item.RetailEndpoint.RetailEndpointHost} \n{e.Message}");
                }
            }
        }
    }
}
