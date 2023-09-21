using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClient.Web.Contracts
{
    public interface ITask : IDisposable
    {
        Task RunAsync(IServiceProvider serviceProvider, Expression<Func<RetailEndpoint, bool>> predicat);
    }

    public interface IJobService
    {
        void AddTask<T>(TimeSpan interval) where T : class, ITask;
    }
}
