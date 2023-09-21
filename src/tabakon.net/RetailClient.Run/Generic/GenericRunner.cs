using Microsoft.EntityFrameworkCore;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Run.Generic {
    public abstract class GenericRunner<TRequest, TResult, TEntity> : IRunner
        where TRequest : RequestToSync
        where TResult : RequestResult
        where TEntity : AbstractCacheEntity {

        protected readonly IServiceProvider _serviceProvider;
        private readonly IRetailEndpointsRepo _retailEndpointsRepo;
        private readonly GenericWS<TRequest, TResult, TEntity> _genericWS;
        private readonly GenericDB<TResult, TEntity> _genericDB;

        public GenericRunner(
            IServiceProvider serviceProvider,
            IRetailEndpointsRepo retailEndpointsRepo,
            GenericWS<TRequest, TResult, TEntity> genericWS,
            GenericDB<TResult, TEntity> genericDB

            ) {
            _serviceProvider = serviceProvider;
            _retailEndpointsRepo = retailEndpointsRepo;
            _genericWS = genericWS;
            _genericDB = genericDB;
        }

        protected abstract IEnumerable<TRequest> BuildRequests(RetailEndpoint item);
        public async Task Run(Expression<Func<RetailEndpoint, bool>> predicat = null) {
            var endpointsQuery = _retailEndpointsRepo
                .GetRetailEndpoints();

            if (predicat != null) {
                endpointsQuery = endpointsQuery.Where(predicat);
            }

            var endpoints = await endpointsQuery.AsNoTracking().ToListAsync();

            foreach (var endpoint in endpoints) {
                foreach (var request in BuildRequests(endpoint)) {
                    await _genericWS.Add(request);
                }
            }


            for (var i = 0; i < 3; i++) {
                await Task.Delay(3000);

                await _genericWS.WaitAll();
                await _genericDB.WaitAll();
            }
        }
    }
}
