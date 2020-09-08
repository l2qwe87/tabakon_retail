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
                dateBegin = DateTime.Now.Date.AddDays(-5);
                var logger = serviceProvider.GetService<ILogger<WorkerRetailDocSelesReport>>();
                logger.LogInformation($"BEGIN WorkerRetailDocSelesReport : {endpoint.RetailEndpointName}");
                
                logger.LogInformation($"END WorkerRetailDocSelesReport : {endpoint.RetailEndpointName} : {arr.Count()}");
                var logger = serviceProvider.GetService<ILogger<WorkerRetailVersion>>();
                logger.LogInformation($"BEGIN WorkerRetailVersion : {endpoint.RetailEndpointName}");

                finally
                {
                    logger.LogInformation($"END WorkerRetailVersion : {endpoint.RetailEndpointName}");
                }
    
                    .Where(r => !r.MarkAsDeleted && r.RetailEndpointHost.Length > 0)
                    .OrderBy(r => r.RetailEndpointName)
    }

}
