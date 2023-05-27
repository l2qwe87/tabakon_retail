using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;
using Tabakon.Queue.Contracts;

namespace RetailClient.Run.Generic {
    public abstract class GenericWS<TRequest, TResult, TEntity> : AbstractWorkerByAsyncQueue<TRequest>
        where TRequest : RequestToSync
        where TResult : RequestResult
        where TEntity : AbstractCacheEntity {

        private readonly IServiceProvider _serviceProvider;
        private readonly GenericDB<TResult, TEntity> _genericDB;
        protected readonly ILogger _logger;

        public GenericWS(
            IServiceProvider serviceProvider,
            GenericDB<TResult, TEntity> genericDB,
            ILogger logger
            ) {

            _serviceProvider = serviceProvider;
            _genericDB = genericDB;
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

        protected abstract TResult BuildRequestReuslt(TRequest item, string json);
        protected abstract Task<string> InvokeWS(TRequest item);

        protected override async Task Do(TRequest item) {
            try {
                var json = (await InvokeWS(item))?.ToString();
                if (json != null && json.StartsWith("[")){
                    var jArray = JArray.Parse(json);
                    var jsonItems = jArray.Select(e => e.ToString()).ToList();
                    foreach (var jsonItem in jsonItems) {
                        await _genericDB.Add(BuildRequestReuslt(item, jsonItem)); ;
                    }
                }
                else {
                    await _genericDB.Add(BuildRequestReuslt(item, json)); ;
                }
            }
            catch (Exception e) {
                _logger.LogError(e, $"{item.RetailEndpoint.RetailEndpointHost} \n{e.Message}");
            }
        }

        protected override void LoggingStatus() {
            _logger.LogInformation(this.GetStatus());
        }
    }
}
