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
            //var cis = new QR(qr);
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
        //public string KI { get; private set; }
        //public string KI_SHORT { get; private set; }



        public QRParser(string qr)
        {
            if (qr.StartsWith("(01)") && qr.IndexOf("(21)", 2) > 0) {
                qr = qr.Replace("(01)", "01").Replace("(21)", "21");
            }

            if (qr.StartsWith("01") && qr.IndexOf("21", 2) >= 12)
            {
                //var qq = ParseGS1String(qr);

                var serialNumberStart = qr.IndexOf("21", 12);
                var priceStart = qr.IndexOf("8005", serialNumberStart);
                var signStart = qr.IndexOf("93", serialNumberStart);

                var end = -1;
                if (priceStart < 0 || signStart < 0)
                {
                    end = Math.Max(priceStart, signStart);
                }
                else
                {
                    end = Math.Min(priceStart, signStart);
                }
                if (end < 0)
                {
                    end = qr.Length;
                }
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
                    //throw new ArgumentException("bad QR", "qr");
                    CIS = qr.Trim();
                    //KI_SHORT = qr;
                    //KI = qr;
                }
                else
                {
                    _gtin = qr.Substring(0, gtin_length);
                    _serialNumber = qr.Substring(gtin_length, serialNumber_length);
                    _price = qr.Substring(gtin_length + serialNumber_length, price_length);
                    _sign = qr.Substring(gtin_length + serialNumber_length + price_length, sign_length);

                    CIS = $"{_gtin }{_serialNumber}".Trim();
                    //KI_SHORT = $"01{_gtin }21{_serialNumber}";
                    //KI = $"{KI_SHORT}8005{_price}96{_sign}";
                }
            }

        }

        /// <summary>
        /// Разбирает GS1-строку на поля по идентификаторам приложений (AI)
        /// </summary>
        private static Dictionary<string, string> ParseGS1String(string gs1String) {
            var fields = new Dictionary<string, string>();
            int pos = 0;

            while (pos < gs1String.Length) {
                // Ищем AI (идентификатор приложения) — обычно 2–4 цифры
                string ai = "";
                for (int i = pos; i < Math.Min(pos + 4, gs1String.Length); i++) {
                    ai += gs1String[i];
                    // Проверяем, является ли AI завершённым (по таблице стандартных AI)
                    if (IsValidAI(ai)) {
                        pos += ai.Length;
                        break;
                    }
                }

                if (string.IsNullOrEmpty(ai) || !IsValidAI(ai))
                    break;

                // Определяем длину данных для этого AI
                int dataLength = GetDataLengthForAI(ai);
                string data = "";

                if (dataLength > 0) {
                    // Фиксированная длина
                    data = gs1String.Substring(pos, dataLength);
                    pos += dataLength;
                } else {
                    // Переменная длина — ищем разделитель (GS, ASCII 29) или конец строки
                    int endPos = gs1String.IndexOf((char)29, pos);
                    if (endPos == -1)
                        endPos = gs1String.Length;

                    data = gs1String.Substring(pos, endPos - pos);
                    pos = endPos + 1; // пропускаем GS
                }

                fields[ai] = data;
            }

            return fields;
        }

        // Список поддерживаемых AI (упрощённый пример)
        private static bool IsValidAI(string ai) {
            string[] validAI = { "01", "21", "10", "11", "17", "91", "92", "93" };
            return validAI.Contains(ai);
        }

        // Длина данных для AI (упрощённый пример)
        private static int GetDataLengthForAI(string ai) {
            switch (ai) {
                case "01": return 14; // GTIN (14 цифр)
                case "21": return 13; // Серийный номер (13 символов)
                case "10": return -1; // Партия (переменная длина)
                case "11": return 6;  // Дата производства (6 цифр: ГГММДД)
                case "17": return 6;  // Срок годности (6 цифр: ГГММДД)
                case "91": return -1; // Код проверки 1 (переменная)
                case "92": return -1; // Код проверки 2 (переменная)
                case "93": return -1; // Криптохвост (переменная)
                default: return -1;
            }
        }
    }
}
