using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RetailClient.Web.Contracts;

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


        [HttpGet("Total")]
        public async Task<object> GetTotalInfo([FromQuery] DateTime date)
        {
            var query = retailEndpointsRepo.GetRetailCashierCheck()
               .IgnoreAutoIncludes()
               .Where(r => r.Date == date.Date)
               .GroupBy(r => r.Date)
               .Select(g => new {
                   Date = g.Key.Date,
                   SumSale = g.Sum(r => r.IsSale ? r.Sum : 0),
                   SumReturn = g.Sum(r => r.IsSale ? 0 : -r.Sum),
                   Sum = g.Sum(r => r.IsSale ? r.Sum : -r.Sum),
                   SumCash = g.Sum(r => r.IsSale ? r.SumCash : -r.SumCash),
                   SumTerminal = g.Sum(r => r.IsSale ? r.SumTerminal : -r.SumTerminal),
               });

            var data = await query.ToListAsync();

            var result = data;

            return result;
        }

        [HttpGet("Info")]
        public async Task<object> GetInfo([FromQuery] DateTime date)
        {
            var query = retailEndpointsRepo.GetRetailCashierCheck()
               .IgnoreAutoIncludes()
               .Where(r => r.Date == date.Date)
               .GroupBy(r => new { r.Date, r.RetailEndpointIdentity, r.StoreRef })
               .Select(g => new {
                   Date = g.Key.Date,
                   RetailEndpointIdentity = g.Key.RetailEndpointIdentity,
                   StoreRef = g.Key.StoreRef,
                   SumSale = g.Sum(r => r.IsSale ? r.Sum : 0),
                   SumReturn = g.Sum(r => r.IsSale ? 0 : -r.Sum),
                   Sum = g.Sum(r => r.IsSale ? r.Sum : -r.Sum),
                   SumCash = g.Sum(r => r.IsSale ? r.SumCash : -r.SumCash),
                   SumTerminal = g.Sum(r => r.IsSale ? r.SumTerminal : -r.SumTerminal),
               });

            var data = await query.ToListAsync();

            var result = data;

            return result;
        }

        [HttpGet("{retailEndpointIdentity}/Info")]
        public async Task<object> GetInfoByRetailEndpointIdentity(string retailEndpointIdentity, [FromQuery] DateTime dateFrom)
        {

            var data = await retailEndpointsRepo.GetRetailCashierCheck()
                .IgnoreAutoIncludes()
                .Where(r => r.Date >= dateFrom)
                .Where(r => r.RetailEndpointIdentity == retailEndpointIdentity)
                .GroupBy(r => new { r.Date, r.RetailEndpointIdentity, r.StoreRef })
                .Select(g => new {
                    Date = g.Key.Date,
                    RetailEndpointIdentity = g.Key.RetailEndpointIdentity,
                    StoreRef = g.Key.StoreRef,
                    SumSale = g.Sum(r => r.IsSale ? r.Sum : 0),
                    SumReturn = g.Sum(r => r.IsSale ? 0 : -r.Sum),
                    Sum = g.Sum(r => r.IsSale ? r.Sum : -r.Sum),
                    SumCash = g.Sum(r => r.IsSale ? r.SumCash : -r.SumCash),
                    SumTerminal = g.Sum(r => r.IsSale ? r.SumTerminal : -r.SumTerminal),
                })
                .ToListAsync();

            var result = data;
                
            return result;

        }

    }
}
