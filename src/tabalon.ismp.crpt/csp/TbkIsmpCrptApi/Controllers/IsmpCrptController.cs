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

        public IsmpCrptController(
            IMarkirovkaClient markirovkaClient,
            ILogger<IsmpCrptController> logger
            )
        {
            _markirovkaClient = markirovkaClient;
            _logger = logger;
        }

        [HttpGet("Info")]
        public async Task<string> InfoGet([FromQuery] IEnumerable<string> ciss)
            => await InfoInternal(ciss);

        [HttpPost("Info")]
        public async Task<string> InfoPost([FromBody] IEnumerable<string> ciss)
            => await InfoInternal(ciss);


        private async Task<string> InfoInternal(IEnumerable<string> ciss)
        {
            //var cis = new QR(qr);
            var codes = ciss
                .Select(cis => new QR(cis))
                .Select(qr => qr.CIS)
                .ToList();
            var resp = await _markirovkaClient.CisesInfo(codes);
            return resp;
        }
    }



    internal class QR
    {
        private QR() { }

        private string _gtin;
        private string _serialNumber;
        private string _price;
        private string _sign;


        public string CIS { get; private set; }
        public string KI { get; private set; }
        public string KI_SHORT { get; private set; }
        public QR(string qr)
        {


            var gtin_length = 14;
            var serialNumber_length = 7;
            var price_length = 4;
            var sign_length = 4;

            if (qr.Length == gtin_length + serialNumber_length)
            {
                price_length = 0;
                sign_length = 0;
            }
            if (qr.Length == gtin_length + serialNumber_length + price_length + sign_length + 2)
            {
                price_length += 2;
            }

            if (qr.Length != gtin_length + serialNumber_length + price_length + sign_length)
            {
                throw new ArgumentException("bad QR", "qr");
            }

            _gtin = qr.Substring(0, gtin_length);
            _serialNumber = qr.Substring(gtin_length, serialNumber_length);
            _price = qr.Substring(gtin_length + serialNumber_length, price_length);
            _sign = qr.Substring(gtin_length + serialNumber_length + price_length, sign_length);

            CIS = $"{_gtin }{_serialNumber}";
            KI_SHORT = $"01{_gtin }21{_serialNumber}";
            KI = $"{KI_SHORT}8005{_price}96{_sign}";

        }
    }
}
