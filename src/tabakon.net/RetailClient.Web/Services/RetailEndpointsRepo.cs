using Microsoft.EntityFrameworkCore;
using RetailClient.Web.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClient.Web.Services
{

    public class RetailEndpointsRepo : IRetailEndpointsRepo
    {
        private readonly TabakonDBContext ctx;
        public RetailEndpointsRepo(TabakonDBContext ctx)
        {
            this.ctx = ctx;
        }

        public IQueryable<RetailEndpoint> GetRetailEndpoints() 
        {
            var endpoints = ctx.RetailEndpoint
                .Where(e => e.MarkAsDeleted == false && e.RetailEndpointHost.Length > 0)
                .Select(r => r);

            return endpoints;
        }

        public IQueryable<RetailDocCashierCheck> GetRetailCashierCheck()
        {
            return ctx.RetailDocCashierCheck.Select(r => r);
        }

        public IQueryable<RetailVersion> GetRetailEndpointsVersion()
        { 
            var versions = ctx.RetailVersion
                .Where(e => e.RetailEndpoint.MarkAsDeleted == false && e.RetailEndpoint.RetailEndpointHost.Length > 0)
                .Select(r => r);

            return versions;
        }

        public IQueryable<RetailExtConfiguration> GetRetailExtConfiguration()
        {
            var extConfiguration = ctx.RetailExtConfiguration
                .Where(e => e.RetailEndpoint.MarkAsDeleted == false && e.RetailEndpoint.RetailEndpointHost.Length > 0)
                .Select(r => r);

            return extConfiguration;
        }
    }
}
