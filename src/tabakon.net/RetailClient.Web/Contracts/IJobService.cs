using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
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
                var logger = scope.ServiceProvider.GetService<ILogger<JobService>>();
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
                                    var logger = scope.ServiceProvider.GetService<ILogger<JobService>>();
                                    logger.LogInformation($"JobService.Run({typeof(T).Namespace}.{typeof(T).Name}); {ex}");
                                }
                                catch (Exception e)
                                {
                                    //arr.Add(e.Message);
                                    var _logger = serviceProvider.GetService<ILogger<JobService>>();
                                    _logger.LogError(e.Message, e);
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
            //using (var scope = serviceProvider.CreateScope())
            //{
            //    var logger = scope.ServiceProvider.GetService<ILogger<JobService>>();
            //    logger.LogInformation($"JobService Dispose");
            //}
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            GC.SuppressFinalize(this);
        }
        #endregion
    }


    public class WorkerRetailDocSelesReport : WorkerT
    {
        public WorkerRetailDocSelesReport(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
        {
            var alwaysSaveResult = false;
            var result = await DoWorkAsync<RetailDocSelesReport>(alwaysSaveResult, async (endpoint) =>
            {
                var arr = new List<string>();
                var dateBegin = DateTime.Now.Date.AddDays(-50);
#if RELEASE
                dateBegin = DateTime.Now.Date.AddDays(-5);
#endif
                var logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport>>();
                logger.LogInformation($"BEGIN WorkerRetailDocSelesReport : {endpoint.RetailEndpointName}");
                while (dateBegin < DateTime.Now)
                {
                    var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                    try
                    {
                        var json = await ws.GetRetailDocSelesReport(dateBegin);
                        var jArray = JArray.Parse(json);
                        var docs = jArray.Select(e => e.ToString()).ToList();
                        arr.AddRange(docs);
                        //var _logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport>>();
                        //_logger.LogWarning(JsonConvert.SerializeObject(docs));
                    }
                    catch (Exception e)
                    {
                        //arr.Add(e.Message);
                        var _logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport>>();
                        _logger.LogError(e.Message,e);
                    }
                    dateBegin = dateBegin.AddDays(1);
                }

                //Console.Out.WriteLine($"WorkerRetailDocSelesReport : {endpoint.RetailEndpointName} : {arr.Count()}");
                
                logger.LogInformation($"END WorkerRetailDocSelesReport : {endpoint.RetailEndpointName} : {arr.Count()}");

                return arr;
            });
        }
    }

    public class WorkerRetailVersion : WorkerT
    {
        public WorkerRetailVersion(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
        {
            var alwaysSaveResult = false;
            var result = await DoWorkAsync<RetailVersion>(alwaysSaveResult, async (endpoint) =>
            {
                var logger = serviceProvider.GetService<ILogger<WorkerRetailVersion>>();
                logger.LogInformation($"BEGIN WorkerRetailVersion : {endpoint.RetailEndpointName}");

                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                try
                {
                    return new[] { (await ws.GetVersionAsync()) };
                }
                catch (Exception e)
                {
                    return (alwaysSaveResult)
                        ? new[] { e.Message }
                        : new string[0];
                }
                finally
                {
                    logger.LogInformation($"END WorkerRetailVersion : {endpoint.RetailEndpointName}");
                }
            });
        }
    }

    public class WorkerPing : WorkerT
    {
        public WorkerPing(IServiceProvider serviceProvider) : base(serviceProvider) { }

        public override async Task RunAsync(IServiceProvider serviceProvider)
        {
            var alwaysSaveResult = true;
            var result = await DoWorkAsync<RetailPing>(alwaysSaveResult, async (endpoint) =>
            {
                var ws = new RetailWSClient(endpoint.RetailEndpointHost, endpoint.RetailEndpointUrl);
                try
                {
                    return new[] { (await ws.PingAsync()).ToString() };
                }
                catch (Exception e) 
                {
                    return (alwaysSaveResult)
                        ? new[] { e.Message } 
                        : new string[0];
                }
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

        protected async Task<IEnumerable<T>> DoWorkAsync<T>(bool alwaysSaveResult, Func<RetailEndpoint, Task<IEnumerable<string>>> func) where T : AbstractCacheEntity
        {
            List<RetailEndpoint> endpoints = null;
            using (var scope = serviceProvider.CreateScope())
            {
                var ctx = scope.ServiceProvider.GetRequiredService<TabakonDBContext>();
                endpoints = await ctx.RetailEndpoint
                    .Where(r => !r.MarkAsDeleted && r.RetailEndpointHost.Length > 0)
                    //.Where(r => r.RetailEndpointHost == "10.101.0.50" || r.RetailEndpointHost == "localhost")
                    .OrderBy(r => r.RetailEndpointName)
                    .Select(r => r)
                    .AsNoTracking()
                    .ToListAsync();
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


        protected async Task<IEnumerable<T>> JobAsync<T>(bool alwaysSaveResult, RetailEndpoint endpoint, Func<RetailEndpoint, Task<IEnumerable<string>>> func) where T : AbstractCacheEntity
        {

            var wsResultArray = await func(endpoint);
            var result = new List<T>();

            foreach(var wsResult in wsResultArray)
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
