using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Net.Http;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using TbkIsmpContracts;
using TbkIsmpCrpt;
using TbkSigner;
using TbkSignerContracts;

namespace TbkTest
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var services = new ServiceCollection();
            //services.AddSingleton<ISigner ,BashSigner>();
            //services.AddSingleton<ISigner , PkgSigner>();
            services.AddSingleton<ISigner, BashFrameworkSigner>();

            services.AddSingleton<IsmpClientConfig>((_) => new IsmpClientConfig 
            { 
                BaseUrl = "https://markirovka.crpt.ru",
                //Thumbprint = "3B5AFA9635BD5EA7B1C3F847A543BBF214BEE297" //SN=Малышев, G=Дмитрий Борисович, 780156595000
                Thumbprint = "B2CE2E0BB37ABA5EDE06ACF0FD70841B8F113BAE" //SN=Хмелева, G=Татьяна Алексеевна,780216064720

            });
            services.AddSingleton<IIsmpClient, IsmpClient>();

            services.AddTransient<HttpClient>((sp)=> {
                var ismpClientConfig = sp.GetRequiredService<IsmpClientConfig>();
                var httpClient = new HttpClient();
                httpClient.BaseAddress = new Uri(ismpClientConfig.BaseUrl);
                return httpClient;
            });
            services.AddSingleton<IMarkirovkaClient, MarkirovkaClient>();

            

            var rootServiceProvider = services.BuildServiceProvider();

            
            using (var scope = rootServiceProvider.CreateScope()) 
            {
                var serviceProvider = scope.ServiceProvider;

                var markirovkaClient = serviceProvider.GetRequiredService<IMarkirovkaClient>();


                

                var qrs = new[] {
                    "04605648031889;BDxaEIAAAAwo1m",
                    "04605648031889;BDxaEIAAAAwo1m",
                    "04610030141428RW=MW\"yACPA1AuI",
                    "04610030141428n-!KgNIACPADrIG",
                    "04610030140322wPpMt37",
                    "00000046201713oAfo+;T",
                    "04606203098064li35i,HADh8Bu85",
                    "04601653033399WnSlxCcACyA7rOc",
                    "00000046212740rb8u'vsACCozBAc",
                    "04606203098064li35i,H",
                    "00000046212740rb8u'vs",
                    "04601653033399WnSlxCc",
                    "0460165303339938>sopS"


                };

                foreach (var qr in qrs) {
                    Console.WriteLine($"========================================");

                    {
                        var q = new QR(qr);
                        var qqq = await markirovkaClient.CisesInfo(q.CIS);
                        Console.WriteLine($"{qqq}");
                    }

                    {
                        var qqq = await markirovkaClient.CisesInfo(qr);
                        Console.WriteLine($"{qqq}");
                    }
                    {
                        var q = new QR(qr);
                        var qqq = await markirovkaClient.CisesInfo(q.KI);
                        Console.WriteLine($"{qqq}");
                    }
                    {
                        var q = new QR(qr);
                        var qqq = await markirovkaClient.CisesInfo(q.KI_SHORT);
                        Console.WriteLine($"{qqq}");
                    }
                }



            }


            Console.WriteLine($"Press any key ...");
            Console.ReadKey();

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
