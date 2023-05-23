using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using RetailClient.Run.RetailPing;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services;
using RetailClient.Web.Services.Jobs;
using Tabakon.DAL;
using Tabakon.Queue.RetailDocCashierCheck;


namespace RetailClient.Run {
    internal class Program {
        static void Main(string[] args) {
#if RELEASE
            Directory.SetCurrentDirectory(Path.GetDirectoryName(System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName));
#endif
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
            .UseWindowsService()
                .ConfigureServices((hostContext, services) => {
                    IConfiguration configuration = hostContext.Configuration;

                    services.AddDbContext<TabakonDBContext>(options => options.UseSqlServer(configuration.GetConnectionString("TabakonDataContext")));
                    services.AddScoped<IRetailEndpointsRepo, RetailEndpointsRepo>();

                    services.AddScoped<HttpClientHandler>(serviceProvider => {
                        var httpClientHandler = new HttpClientHandler();
                        httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => { return true; };
                        return httpClientHandler;
                    });

                    services.AddScoped<HttpClient>(serviceProvider => {
                        var httpClientHandler = serviceProvider.GetRequiredService<HttpClientHandler>();
                        var httpClient = new HttpClient(httpClientHandler);
                        var httpClientTimeout = serviceProvider.GetRequiredService<IConfiguration>().GetValue<double>("HttpClient:Timeout");
                        httpClient.Timeout = TimeSpan.FromSeconds(httpClientTimeout);
                        return httpClient;
                    });


                    services.AddRetailPinger();

                    services.AddHostedService<Runner>();
                });
    }

    internal class Runner : BackgroundService {
        private readonly IServiceProvider _serviceProvider;

        public Runner(IServiceProvider serviceProvider) {
            _serviceProvider = serviceProvider;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken) {
            
            var worker = _serviceProvider.GetRequiredService<RetailPinger>();
            await worker.Run();

            await Task.Delay(3000);

            await _serviceProvider.GetRequiredService<RetailPingerWS>().WaitAll();
            await _serviceProvider.GetRequiredService<RetailPingerDB>().WaitAll();

            var logger = _serviceProvider.GetService<ILogger<Runner>>();
            logger.LogInformation("Complited");

            _serviceProvider.GetRequiredService<IHostApplicationLifetime>().StopApplication();
        }
    }
}