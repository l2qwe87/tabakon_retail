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

        public async Task<IEnumerable<RetailEndpoint>> GetRetailEndpointsAsync() 
        {
            var endpoints = await ctx.RetailEndpoint
                .Where(e => e.MarkAsDeleted == false && e.RetailEndpointHost.Length > 0)
                .Select(r => r).ToListAsync();

            return endpoints;
        }

        public async Task<IEnumerable<RetailVersion>> GetRetailEndpointsVersionAsync()
        { 
            var versions = await ctx.RetailVersion
                .Where(e => e.RetailEndpoint.MarkAsDeleted == false && e.RetailEndpoint.RetailEndpointHost.Length > 0)
                .Select(r => r).ToListAsync();

            return versions;
        }

        public async Task<IEnumerable<RetailExtConfiguration>> GetRetailExtConfigurationAsync()
        {
            var extConfiguration = await ctx.RetailExtConfiguration
                .Where(e => e.RetailEndpoint.MarkAsDeleted == false && e.RetailEndpoint.RetailEndpointHost.Length > 0)
                .Select(r => r).ToListAsync();

            return extConfiguration;
        }
    }
}
