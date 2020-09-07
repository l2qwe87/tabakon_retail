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
            var endpoints = await ctx.RetailEndpoint.Select(r => r).ToListAsync();

            return endpoints;
        }
    }
}
