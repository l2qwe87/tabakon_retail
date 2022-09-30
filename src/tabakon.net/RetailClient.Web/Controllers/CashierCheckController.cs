using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using RetailClient;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services.Jobs;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClientTests.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CashierCheckController : ControllerBase
    {
        private readonly IRetailEndpointsRepo retailEndpointsRepo;
        private readonly IServiceProvider serviceProvider;


        public CashierCheckController(
            IRetailEndpointsRepo retailEndpointsRepo,
            IServiceProvider serviceProvider
            )
        {
            this.retailEndpointsRepo = retailEndpointsRepo;
            this.serviceProvider = serviceProvider;
        }

        [HttpGet("{retailEndpointIdentity}/Info")]
        public async Task<object> GetInfo(string retailEndpointIdentity)
        {

            var data = await retailEndpointsRepo.GetRetailCashierCheck()
                .Include(r => r.PaymentDetail)
                .Where(r => r.RetailEndpointIdentity == retailEndpointIdentity)
                .ToListAsync();

           var result = data.GroupBy(r => new { r.Date, r.RetailEndpointIdentity})
                .Select(g => new {
                    Date = g.Key.Date,
                    RetailEndpointIdentity = g.Key.RetailEndpointIdentity,
                    SumSale = g.Sum(r => r.IsSale ? r.Sum : 0),
                    SumReturn = g.Sum(r => r.IsSale ? 0 : -r.Sum),
                    Sum = g.Sum(r => r.IsSale ? r.Sum : -r.Sum),
                    SumCash = g.Sum(r => r.PaymentDetail.Where(p => p.IsCash).Sum(s => r.IsSale ? s.Sum : -s.Sum)),
                    SumTerminal = g.Sum(r => r.PaymentDetail.Where(p => !p.IsCash).Sum(s => s.Sum))
                });
                
            return result;

        }

    }
}
