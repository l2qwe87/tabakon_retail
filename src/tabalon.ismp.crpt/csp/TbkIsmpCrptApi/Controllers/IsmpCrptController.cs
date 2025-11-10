using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TbkIsmpContracts;

namespace TbkIsmpCrptApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class IsmpCrptController : ControllerBase
    {

        private readonly ILogger<IsmpCrptController> _logger;
        private readonly IMarkirovkaClient _markirovkaClient;
        private readonly IMarkirovkaAuth _markirovkaAuth;

        public IsmpCrptController(
            IMarkirovkaClient markirovkaClient,
            IMarkirovkaAuth markirovkaAuth,
            ILogger<IsmpCrptController> logger
            )
        {
            _markirovkaClient = markirovkaClient;
            _markirovkaAuth = markirovkaAuth;
            _logger = logger;
        }

        [HttpGet("Token")]
        public TokenInfo GetToken()
            => _markirovkaAuth.GetToken();

        [HttpGet("Info")]
        public async Task<string> InfoGet([FromQuery] IEnumerable<string> ciss, [FromQuery] bool withOutQRParse = false)
            => await InfoInternal(ciss, withOutQRParse);

        [HttpPost("Info")]
        public async Task<string> InfoPost([FromBody] IEnumerable<string> ciss, [FromQuery] bool withOutQRParse = false)
            => await InfoInternal(ciss, withOutQRParse);

        [HttpGet("ProductInfo")]
        public async Task<string> ProductInfo([FromQuery] string cis, [FromQuery] bool withOutQRParse = false)
            => await ProductInfoInternal(cis, withOutQRParse);

        private async Task<string> InfoInternal(IEnumerable<string> ciss, bool withOutQRParse)
        {
            var codes = ciss;
            if (!withOutQRParse)
            {
                codes = ciss
                    .Select(cis => new QRParser(cis))
                    .Select(qr => qr.CIS)
                    .ToList();
            }
            var resp = await _markirovkaClient.CisesInfo(codes);
            return resp;
        }

        private async Task<string> ProductInfoInternal(string cis, bool withOutQRParse)
        {
            var code = cis;
            if (!withOutQRParse)
            {
                var qr = new QRParser(cis);
                code = qr.CIS;
            }

            var resp = await _markirovkaClient.ProductInfo(code);
            return resp;
        }
    }
}
