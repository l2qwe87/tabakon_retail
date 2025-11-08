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

        private async Task<string> InfoInternal(IEnumerable<string> ciss, bool withOutQRParse) {
            var codes = ciss;
            if (!withOutQRParse) {
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
            if (!withOutQRParse) {
                var qr = new QRParser(cis);
                code = qr.CIS;
            }

            var resp = await _markirovkaClient.ProductInfo(code);
            return resp;
        }
    }

    public class QRParser
    {
        private QRParser() { }

        private string _gtin;
        private string _serialNumber;
        private string _price;
        private string _sign;

        public string CIS { get; private set; }

        public QRParser(string qr)
        {
            if (qr.StartsWith("(01)") && qr.IndexOf("(21)", 2) > 0) {
                qr = qr.Replace("(01)", "01").Replace("(21)", "21");
            }

            if (qr.StartsWith("01") && qr.IndexOf("21", 2) >= 12)
            {
                var serialNumberStart = qr.IndexOf("21", 12);
                var markers = new[] { "8005", "93", "91" };
                int found = -1;
                foreach (var m in markers)
                {
                    var p = qr.IndexOf(m, serialNumberStart);
                    if (p >= 0 && (found < 0 || p < found))
                    {
                        found = p;
                    }
                }

                var end = (found >= 0) ? found : qr.Length;
                CIS = qr.Substring(0, end).Trim();
            }
            else
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
                if (qr.Length == gtin_length + serialNumber_length + price_length)
                {
                    sign_length = 0;
                }

                if (qr.Length != gtin_length + serialNumber_length + price_length + sign_length)
                {
                    CIS = qr.Trim();
                }
                else
                {
                    _gtin = qr.Substring(0, gtin_length);
                    _serialNumber = qr.Substring(gtin_length, serialNumber_length);
                    _price = qr.Substring(gtin_length + serialNumber_length, price_length);
                    _sign = qr.Substring(gtin_length + serialNumber_length + price_length, sign_length);

                    CIS = $"{_gtin }{_serialNumber}".Trim();
                }
            }

        }

        private static Dictionary<string, string> ParseGS1String(string gs1String) {
            var fields = new Dictionary<string, string>();
            int pos = 0;

            while (pos < gs1String.Length) {
                string ai = "";
                for (int i = pos; i < Math.Min(pos + 4, gs1String.Length); i++) {
                    ai += gs1String[i];
                    if (IsValidAI(ai)) {
                        pos += ai.Length;
                        break;
                    }
                }

                if (string.IsNullOrEmpty(ai) || !IsValidAI(ai))
                    break;

                int dataLength = GetDataLengthForAI(ai);
                string data = "";

                if (dataLength > 0) {
                    data = gs1String.Substring(pos, dataLength);
                    pos += dataLength;
                } else {
                    int endPos = gs1String.IndexOf((char)29, pos);
                    if (endPos == -1)
                        endPos = gs1String.Length;

                    data = gs1String.Substring(pos, endPos - pos);
                    pos = endPos + 1;
                }

                fields[ai] = data;
            }

            return fields;
        }

        private static bool IsValidAI(string ai) {
            string[] validAI = { "01", "21", "10", "11", "17", "91", "92", "93" };
            return validAI.Contains(ai);
        }

        private static int GetDataLengthForAI(string ai) {
            switch (ai) {
                case "01": return 14;
                case "21": return 13;
                case "10": return -1;
                case "11": return 6;
                case "17": return 6;
                case "91": return -1;
                case "92": return -1;
                case "93": return -1;
                default: return -1;
            }
        }
    }
}
