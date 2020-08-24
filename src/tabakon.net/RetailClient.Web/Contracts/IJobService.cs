using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClient.Web.Contracts
{
    public interface ITask : IDisposable
    {
        Task RunAsync(IServiceProvider serviceProvider);
    }

    public interface IJobService
    {
        void AddTask<T>(TimeSpan interval) where T : class, ITask;
    }



    public class JobService : IJobService, IDisposable
    {

        private readonly IServiceProvider serviceProvider;
        private bool isRunning = true;
        public JobService(IServiceProvider serviceProvider)
        {
            this.serviceProvider = serviceProvider;
        }


        public void AddTask<T>(TimeSpan interval) where T : class, ITask
        {
            using (var scope = serviceProvider.CreateScope())
            {
                var logger = scope.ServiceProvider.GetService<ILogger<ITask>>();
                logger.LogInformation($"JobService Setup task ({typeof(T).Namespace}.{typeof(T).Name}) interval {interval.Seconds} sec.");
            }
            Task.Run(async () =>
            {
                while (isRunning)
                {
                    try
                    {
                        using (var scope = serviceProvider.CreateScope())
                        {
                            var task = scope.ServiceProvider.GetRequiredService<T>();

                            await (task as ITask).RunAsync(scope.ServiceProvider);

                        }
                        if (isRunning)
                        {
                            await Task.Delay(interval);
                        }
                    }
                    catch (Exception ex)
                    {
                        using (var scope = serviceProvider.CreateScope())
                        {
                            //var logger = scope.ServiceProvider.GetService<ILoggerService>();
                            //logger.WriteLogAsync(new LogEntry($"JobService.Run({typeof(T).Namespace}.{typeof(T).Name})", System.Diagnostics.TraceEventType.Error));
                            Task.Run(() =>
                            {
                                try
                                {
                                    var logger = scope.ServiceProvider.GetService<ILogger>();
                                    logger.LogInformation($"JobService.Run({typeof(T).Namespace}.{typeof(T).Name}); {ex}");
                                }
                                catch
                                {
                                }
                            }).Wait(TimeSpan.FromMilliseconds(500));
                        }
                    }
                }
            });
        }

        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                    isRunning = false;
                }

                // TODO: free unmanaged resources (unmanaged objects) and override a finalizer below.
                // TODO: set large fields to null.

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        // ~JobService() {
        //   // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
        //   Dispose(false);
        // }

        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            using (var scope = serviceProvider.CreateScope())
            {
                var logger = scope.ServiceProvider.GetService<ILogger>();
                logger.LogInformation($"JobService Dispose");
            }
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            GC.SuppressFinalize(this);
        }
        #endregion
    }



    public class WorkerRetailVersion : WorkerT
    {
        public WorkerRetailVersion(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
        {
            var result = await DoWorkAsync<RetailVersion>(false, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                return await ws.GetVersionAsync();
            });
        }
    }

    public class WorkerPing : WorkerT
    {
        public WorkerPing(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
        {
            var result = await DoWorkAsync<RetailPing>(true, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                return await ws.PingAsync();
            });
        }
    }

    public abstract class  WorkerT : ITask 
    {

        protected readonly IServiceProvider serviceProvider;
        public WorkerT(IServiceProvider serviceProvider) 
        {
            this.serviceProvider = serviceProvider;
        }
       
        public abstract Task RunAsync(IServiceProvider serviceProvider);

        protected async Task<IEnumerable<T>> DoWorkAsync<T>(bool alwaysSaveResult, Func<RetailEndpoint, Task<object>> func) where T : AbstractCacheEntity
        {
            List<RetailEndpoint> endpoints = null;
            using (var scope = serviceProvider.CreateScope())
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                endpoints = await ctx.RetailEndpoint.Select(r => r).AsNoTracking().ToListAsync();
            }

            var tasks = endpoints.Select(async endpoint =>
            {
                return await JobAsync<T>(alwaysSaveResult, endpoint, func);
            });
            await Task.WhenAll(tasks);

            using (var scope = serviceProvider.CreateScope())
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var result = await ctx.Set<T>().Select(r => r).AsNoTracking().ToListAsync();
                return result;
            }
        }

        protected async Task<T> JobAsync<T>(bool alwaysSaveResult, RetailEndpoint endpoint, Func<RetailEndpoint, Task<object>> func) where T : AbstractCacheEntity
        {
            using (var scope = serviceProvider.CreateScope())
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                var dbset = ctx.Set<T>();
                var entity = dbset.FirstOrDefault(r => r.RetailEndpointIdentity == endpoint.RetailEndpointIdentity);
                if (entity == null)
                {
                    entity = Activator.CreateInstance<T>();
                    //entity.RetailEndpoint = endpoint;
                    entity.RetailEndpointIdentity = endpoint.RetailEndpointIdentity;

                    await dbset.AddAsync(entity);
                }

                string jsonData = entity.JsonData;
                try
                {
                    var wsResult = await func(endpoint);
                    entity.LastCheck = DateTime.Now;
                    entity.JsonData = JsonConvert.SerializeObject(wsResult);
                }
                catch (Exception e)
                {
                    if (alwaysSaveResult || entity.JsonData == null)
                    {
                        entity.JsonData = e.Message;
                        entity.LastCheck = DateTime.Now;
                    }

                }

                await ctx.SaveChangesAsync();
                return entity;
            }
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
