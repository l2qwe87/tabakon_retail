using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using RetailClient.Web.Contracts;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClientTests.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RetailEndpointsController : ControllerBase
    {
        private readonly IRetailEndpointsRepo retailEndpointsRepo;
        
        public RetailEndpointsController(IRetailEndpointsRepo retailEndpointsRepo)
        {
            this.retailEndpointsRepo = retailEndpointsRepo;
        }
        [HttpGet]
        public async Task<IEnumerable<RetailEndpoint>> Get()
        {
            var endpoints = await retailEndpointsRepo.GetRetailEndpointsAsync();
            
            return endpoints;
        }
    }
}
