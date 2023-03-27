using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using RetailClient.Web.Contracts;
using System;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;
using Tabakon.Queue.RetailDocCashierCheck;
using static System.Formats.Asn1.AsnWriter;

namespace RetailClient.Web.Services.Jobs {
    public class _WorkerRetailDocCashierCheck : ITask {
        private bool disposedValue;

        public _WorkerRetailDocCashierCheck() {
        }

        public async Task RunAsync(IServiceProvider serviceProvider, Func<RetailEndpoint, bool> predicat) {


            var retailEndpointsRepo = serviceProvider.GetRequiredService<IRetailEndpointsRepo>();
            var endpoints = await retailEndpointsRepo
                .GetRetailEndpoints()
                .AsNoTracking()
                .ToListAsync();
            var worker = serviceProvider.GetService<SyncRetailDocCashierCheckWorkerByAsyncQueue>();


            var date = DateTime.Now;

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
