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

                    services.AddSingleton<IJobService, JobService>();
                    services.AddScoped<WorkerRetailVersion, WorkerRetailVersion>();
                    services.AddScoped<WorkerPing, WorkerPing>();
                    services.AddScoped<WorkerRetailExtConfiguration, WorkerRetailExtConfiguration>();

                    services.AddScoped<WorkerRetailDocSelesReport, WorkerRetailDocSelesReport>();

                    services.AddScoped<IRetailEndpointsRepo, RetailEndpointsRepo>();

                    services.AddHostedService<Worker>();
                });
    }
}
