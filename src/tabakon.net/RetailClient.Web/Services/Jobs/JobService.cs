using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime;
using System.Threading.Tasks;

namespace RetailClient.Web.Services.Jobs
{
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

                            await (task as ITask).RunAsync(scope.ServiceProvider, null);

                        }
                        if (isRunning)
                        {
                            await RealTimeDelay(interval);
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
                                    _logger.LogError(e, e.Message);
                                }
                                Task.Delay(TimeSpan.FromSeconds(5)).Wait();
                            }).Wait(TimeSpan.FromMilliseconds(500));
                        }
                    }
                }
            });
        }



        private static Task RealTimeDelay(TimeSpan delay) =>
            RealTimeDelay(delay, TimeSpan.FromSeconds(3));

        private static async Task RealTimeDelay(TimeSpan delay, TimeSpan precision) {
            DateTime start = DateTime.Now;
            DateTime end = start + delay;

            while (DateTime.Now < end || DateTime.Now.Hour < 9 || DateTime.Now.Hour > 23) {
                await Task.Delay(precision);
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
}
