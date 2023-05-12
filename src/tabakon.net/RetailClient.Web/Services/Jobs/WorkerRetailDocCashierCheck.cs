using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using RetailClient.Web.Contracts;
using System;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;
using Tabakon.Queue.RetailDocCashierCheck;
using static System.Formats.Asn1.AsnWriter;

namespace RetailClient.Web.Services.Jobs {

    public class WorkerRetailDocCashierCheck_1Day : WorkerRetailDocCashierCheck
    {
        public WorkerRetailDocCashierCheck_1Day()
        {
        }

        protected override int RequCountDay => 1;
    }

    public class WorkerRetailDocCashierCheck_2Day : WorkerRetailDocCashierCheck
    {
        public WorkerRetailDocCashierCheck_2Day()
        {
        }

        protected override int RequCountDay => 2;
    }

    public class WorkerRetailDocCashierCheck_5Day : WorkerRetailDocCashierCheck
    {
        public WorkerRetailDocCashierCheck_5Day()
        {
        }

        protected override int RequCountDay => 5;
    }

    public class WorkerRetailDocCashierCheck_30Day : WorkerRetailDocCashierCheck
    {
        public WorkerRetailDocCashierCheck_30Day()
        {
        }

        protected override int RequCountDay => 30;
    }


    public class WorkerRetailDocCashierCheck_90Day : WorkerRetailDocCashierCheck
    {
        public WorkerRetailDocCashierCheck_90Day()
        {
        }

        protected override int RequCountDay => 90;
    }

    public class WorkerRetailDocCashierCheck : ITask {
        private bool disposedValue;
        protected virtual int RequCountDay => 0;

        public WorkerRetailDocCashierCheck() {
        }

        public async Task WaitAll(IServiceProvider serviceProvider) {

            await serviceProvider.GetService<SyncRetailDocCashierCheckWorkerByAsyncQueue>().WaitAll();
            await serviceProvider.GetService<SaveRetailDocCashierCheckWorkerByAsyncQueue>().WaitAll();
        }
        public async Task RunAsync(IServiceProvider serviceProvider, Expression<Func<RetailEndpoint, bool>> predicat) {


            var retailEndpointsRepo = serviceProvider.GetRequiredService<IRetailEndpointsRepo>();
            var endpointsQuery = retailEndpointsRepo
                .GetRetailEndpoints();

            if (predicat != null)
            {
                endpointsQuery = endpointsQuery.Where(predicat);
            }

            var endpoints = await endpointsQuery.AsNoTracking().ToListAsync();

            var worker = serviceProvider.GetService<SyncRetailDocCashierCheckWorkerByAsyncQueue>();


            var date = DateTime.Now.Date.AddDays(-RequCountDay);

            foreach (var endpoint in endpoints) {
                await worker.Add(new SyncRetailDocCashierCheck() {
                    RetailEndpoint = endpoint,
                    Date = date
                });
            }
        }

        protected virtual void Dispose(bool disposing) {
            if (!disposedValue) {
                if (disposing) {
                    // TODO: dispose managed state (managed objects)
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
            }
        }

        public void Dispose() {
            // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
            Dispose(disposing: true);
            GC.SuppressFinalize(this);
        }
    }
}
