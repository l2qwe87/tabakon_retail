using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClient.Web.Services.Jobs
{
    public abstract class WorkerT : ITask
    {

        protected readonly IServiceProvider serviceProvider;
        public WorkerT(IServiceProvider serviceProvider)
        {
            this.serviceProvider = serviceProvider;
        }

        public abstract Task RunAsync(IServiceProvider serviceProvider, Func<RetailEndpoint, bool> predicat = null);

        protected async Task DoWorkAsync<T>(bool alwaysSaveResult, Func<RetailEndpoint, Task<IEnumerable<string>>> func, Func<RetailEndpoint, bool> predicat) where T : AbstractCacheEntity
        {
            IEnumerable<RetailEndpoint> endpoints = null;
            using (var scope = serviceProvider.CreateScope())
            {
                var retailEndpointsRepo = scope.ServiceProvider.GetRequiredService<IRetailEndpointsRepo>();
                endpoints = await retailEndpointsRepo
                    .GetRetailEndpoints()
                    .AsNoTracking()
                    .ToListAsync();
#if DEBUG
                //endpoints = endpoints.Concat(endpoints).Concat(endpoints).Concat(endpoints)
                //    .Concat(endpoints).Concat(endpoints).Concat(endpoints).Concat(endpoints).Concat(endpoints).Concat(endpoints)
                //    .Concat(endpoints).Concat(endpoints).Concat(endpoints).Concat(endpoints).Concat(endpoints).Concat(endpoints);
#endif
            }
            if (predicat != null) {
                endpoints = endpoints.Where(e => predicat(e));
            }

            //Parallel.ForEach(endpoints, (endpoint =>
            //{
            //    JobAsync<T>(alwaysSaveResult, endpoint, func).Wait();
            //}));
            //var tasks = endpoints.Select(async endpoint =>
            //{
            //    return await JobAsync<T>(alwaysSaveResult, endpoint, func);
            //});
            //await Task.WhenAll(tasks);

            var taskCount = 6;
            var max = endpoints.Count();
            var part = (max / taskCount)+1;
            var tasks = Enumerable.Range(0, taskCount).Select(async i => 
            {
                var skip = i * part;
                var take = part;
                if ((skip + take) > max)
                {
                    take = max - skip;
                }
                var toDo = endpoints.Skip(skip).Take(take);
                foreach (var endpoint in toDo)
                {
                    await JobAsync<T>(alwaysSaveResult, endpoint, func);
                }              
                
            });

            //var tasks = endpoints.Select(async endpoint =>
            //{
            //    return await JobAsync<T>(alwaysSaveResult, endpoint, func);
            //});
            await Task.WhenAll(tasks);

            //using (var scope = serviceProvider.CreateScope())
            //{
            //    var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
            //    var result = await ctx.Set<T>().Select(r => r).AsNoTracking().ToListAsync();
            //    return result;
            //}
        }


        protected async Task<IEnumerable<T>> JobAsync<T>(bool alwaysSaveResult, RetailEndpoint endpoint, Func<RetailEndpoint, Task<IEnumerable<string>>> func) where T : AbstractCacheEntity
        {

            var wsResultArray = await func(endpoint);
            var result = new List<T>();

            using (var scope = serviceProvider.CreateScope())
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var dbset = ctx.Set<T>();
                foreach (var wsResult in wsResultArray)
                {
                    AbstractCacheEntity entity = Activator.CreateInstance<T>()
                        .PopulateData(endpoint)
                        .PopulateData(wsResult);

                    if (entity is AbstractDocEntity) {
                        entity = dbset.FirstOrDefault(e => (e as AbstractDocEntity).DocRef == (entity as AbstractDocEntity).DocRef);
                    }
                    else{
                        entity = dbset.FirstOrDefault(entity.IsEquals<T>().Compile());
                    }

                    
                    if (entity == null)
                    {
                        entity = (Activator.CreateInstance<T>())
                            .PopulateData(endpoint)
                            .PopulateData(wsResult);

                        await dbset.AddAsync(entity as T);
                    }

                    string jsonData = entity.JsonData;
                    entity.LastCheck = DateTime.Now;
                    entity.PopulateData(wsResult);

                    result.Add(entity as T);
                }
                await ctx.SaveChangesAsync();
            }

            return result;
        }

        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    ///////////////
                }
                disposedValue = true;
            }
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
            
            GCSettings.LargeObjectHeapCompactionMode = GCLargeObjectHeapCompactionMode.CompactOnce;
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }
        #endregion
    }
}
