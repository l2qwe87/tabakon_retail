using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using RetailClient.Web.Contracts;
using System;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Run.RetailPing {

    public class RetailPingRunner {
        private readonly IServiceProvider _serviceProvider;
        private readonly IRetailEndpointsRepo _retailEndpointsRepo;

        public RetailPingRunner(
            IServiceProvider serviceProvider,
            IRetailEndpointsRepo retailEndpointsRepo
            ) {
            _serviceProvider = serviceProvider;
            _retailEndpointsRepo = retailEndpointsRepo;
        }

        public async Task Run(Expression<Func<RetailEndpoint, bool>> predicat = null) {
            var endpointsQuery = _retailEndpointsRepo
                .GetRetailEndpoints();

            if (predicat != null) {
                endpointsQuery = endpointsQuery.Where(predicat);
            }

            var endpoints = await endpointsQuery.AsNoTracking().ToListAsync();

            var worker = _serviceProvider.GetService<RetailPingerWS>();


            foreach (var endpoint in endpoints) {
                await worker.Add(new RetailPingRequestToSync() {
                    RetailEndpoint = endpoint
                });
            }

            await Task.Delay(3000);

            await _serviceProvider.GetRequiredService<RetailPingerWS>().WaitAll();
            await _serviceProvider.GetRequiredService<RetailPingerDB>().WaitAll();
        }
    }
}
