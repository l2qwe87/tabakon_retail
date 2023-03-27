using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services;
using RetailClient.Web.Services.Jobs;
using Tabakon.DAL;
using Tabakon.Queue.RetailDocCashierCheck;

namespace RetailClient.Worker
{
    public class Program
    {
        public static void Main(string[] args)
        {
#if RELEASE
            Directory.SetCurrentDirectory(Path.GetDirectoryName(System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName));
#endif
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
            .UseWindowsService()
                .ConfigureServices((hostContext, services) =>
                {
                    IConfiguration configuration = hostContext.Configuration;

                    services.AddDbContext<TabakonDBContext>(options => options.UseSqlServer(configuration.GetConnectionString("TabakonDataContext")));

                    services.AddScoped<HttpClientHandler>(serviceProvider =>
                    {
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


                    
                    var jobConfig = new JobConfig();
                    //Version
                    if (args.Contains("Version") || args.Length == 0)
                    {
                        jobConfig.Version = true;
                    }
                    //Ping
                    if (args.Contains("Ping") || args.Length == 0)
                    {
                        jobConfig.Ping = true;
                    }
                    //StoreBalance
                    if (args.Contains("StoreBalance") || args.Length == 0)
                    {
                        jobConfig.StoreBalance = true;
                    }
                    //SelesReport
                    if (args.Contains("SelesReport") || args.Length == 0)
                    {
                        jobConfig.SelesReport = true;
                    }
                    //CashierCheck
                    if (args.Contains("CashierCheck") || args.Length == 0)
                    {
                        jobConfig.CashierCheck = true;
                    }
                    
                    services.AddSingleton<IJobService, JobService>();
                    services.AddSingleton<JobConfig>(jobConfig);

                    services.AddScoped<WorkerRetailVersion, WorkerRetailVersion>();
                    services.AddScoped<WorkerPing, WorkerPing>();
                    services.AddScoped<WorkerRetailExtConfiguration, WorkerRetailExtConfiguration>();
                    services.AddScoped<WorkerRetailGetStoreBalance, WorkerRetailGetStoreBalance>();
                    services.AddScoped<WorkerRetailDocSelesReport, WorkerRetailDocSelesReport>();
                    services.AddScoped<WorkerRetailDocSelesReport_NEW, WorkerRetailDocSelesReport_NEW>();
                   
                    //services.AddScoped<WorkerRetailDocCashierCheck_1Day, WorkerRetailDocCashierCheck_1Day>();
                    //services.AddScoped<WorkerRetailDocCashierCheck_2Day, WorkerRetailDocCashierCheck_2Day>();
                    //services.AddScoped<WorkerRetailDocCashierCheck_5Day, WorkerRetailDocCashierCheck_5Day>();
                    //services.AddScoped<WorkerRetailDocCashierCheck_30Day, WorkerRetailDocCashierCheck_30Day>();
                    //services.AddScoped<WorkerRetailDocCashierCheck_90Day, WorkerRetailDocCashierCheck_90Day>();

                    services.AddScoped<_WorkerRetailDocCashierCheck, _WorkerRetailDocCashierCheck>();

                    services.AddSingleton<SyncRetailDocCashierCheckWorkerByAsyncQueue, SyncRetailDocCashierCheckWorkerByAsyncQueue>();
                    services.AddSingleton<SaveRetailDocCashierCheckWorkerByAsyncQueue, SaveRetailDocCashierCheckWorkerByAsyncQueue>();

                    services.AddScoped<IRetailEndpointsRepo, RetailEndpointsRepo>();

                    services.AddHostedService<Worker>();
                });
    }

    public class JobConfig { 
        public bool Version { get; set; }
        public bool Ping { get; set; }
        public bool StoreBalance { get; set; }
        public bool SelesReport { get; set; }
        public bool CashierCheck { get; set; }
    }
}
