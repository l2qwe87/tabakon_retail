using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
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

        protected async Task<IEnumerable<T>> DoWorkAsync<T>(bool alwaysSaveResult, Func<RetailEndpoint, Task<IEnumerable<string>>> func, Func<RetailEndpoint, bool> predicat) where T : AbstractCacheEntity
        {
            IEnumerable<RetailEndpoint> endpoints = null;
            using (var scope = serviceProvider.CreateScope())
            {
                var retailEndpointsRepo = scope.ServiceProvider.GetRequiredService<IRetailEndpointsRepo>();
                endpoints = await retailEndpointsRepo
                    .GetRetailEndpoints()
                    .AsNoTracking()
                    .ToListAsync();
            }
            if (predicat != null) {
                endpoints = endpoints.Where(e => predicat(e));
            }

            Parallel.ForEach(endpoints, (endpoint =>
            {
                JobAsync<T>(alwaysSaveResult, endpoint, func).Wait();
            }));
            //var tasks = endpoints.Select(async endpoint =>
            //{
            //    return await JobAsync<T>(alwaysSaveResult, endpoint, func);
            //});
            //await Task.WhenAll(tasks);

            using (var scope = serviceProvider.CreateScope())
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var result = await ctx.Set<T>().Select(r => r).AsNoTracking().ToListAsync();
                return result;
            }
        }


        protected async Task<IEnumerable<T>> JobAsync<T>(bool alwaysSaveResult, RetailEndpoint endpoint, Func<RetailEndpoint, Task<IEnumerable<string>>> func) where T : AbstractCacheEntity
        {

            var wsResultArray = await func(endpoint);
            var result = new List<T>();

            foreach (var wsResult in wsResultArray)
            {
                using (var scope = serviceProvider.CreateScope())
                {
                    var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                    var dbset = ctx.Set<T>();

                    AbstractCacheEntity entity = Activator.CreateInstance<T>()
                        .PopulateData(endpoint)
                        .PopulateData(wsResult);

                    entity = dbset.FirstOrDefault(entity.IsEquals<T>().Compile());
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

                    await ctx.SaveChangesAsync();
                    result.Add(entity as T);
                }
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
        }
        #endregion
    }
}
