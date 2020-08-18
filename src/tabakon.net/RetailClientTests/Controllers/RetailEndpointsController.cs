using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClientTests.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RetailEndpointsController : ControllerBase
    {

        private readonly TabakonDBContext ctx;
        public RetailEndpointsController(TabakonDBContext ctx)
        {
            this.ctx = ctx;
        }
        [HttpGet("Get")]
        public async Task<IEnumerable<RetailEndpoint>> Get()
        {
            var endpoints = await ctx.RetailEndpoint.Select(r => r).ToListAsync();
            return endpoints;
        }

        

    }
}
