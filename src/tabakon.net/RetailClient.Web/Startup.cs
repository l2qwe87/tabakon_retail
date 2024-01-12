using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Tabakon.DAL;
using Microsoft.EntityFrameworkCore;
using RetailClient.Web.Contracts;
using RetailClient.Web.Services.Jobs;
using RetailClient.Web.Services;
using System.Net.Http;
using System.Security.Policy;
using System.Net.Http.Headers;
using Tabakon.Queue.RetailDocCashierCheck;
using RetailClient.Web.Controllers;

namespace RetailClient.Web {



    public class IsmpHttpClient : HttpClient {
        public IsmpHttpClient(HttpMessageHandler handler) : base(handler) { }
    }

    public class Startup {
        private static IServiceScope serviceScope;
        public Startup(IConfiguration configuration) {
            Configuration = configuration;

            var host = Configuration.GetSection("IsmpCrpt").GetValue<string>("Host");
            var timeout = Configuration.GetValue<double>("HttpClient:Timeout");

            Console.WriteLine($"===============");
            Console.WriteLine($"host : {host}");
            Console.WriteLine($"timeout  : {timeout}");
            Console.WriteLine($"===============");
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services) {
            services.AddControllers();
            services.AddCors();

            services.AddDbContextPool<TabakonDBContext>(options => {
                Console.WriteLine("============= TabakonDataContext =============");
                Console.WriteLine(Configuration.GetConnectionString("TabakonDataContext"));
                Console.WriteLine("=============");
                options.UseSqlServer(Configuration.GetConnectionString("TabakonDataContext"));
            }, 20);

            services.AddHttpClient<IsmpCrptApiClient>("IsmpCrptApiClient",
                client => {
                    client.BaseAddress = new Uri(Configuration.GetValue<string>("IsmpCrpt:Host"));
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                });


            //services.AddSingleton<IJobService, JobService>();

            services.AddScoped<WorkerRetailVersion, WorkerRetailVersion>();
            services.AddScoped<WorkerPing, WorkerPing>();
            services.AddScoped<WorkerRetailExtConfiguration, WorkerRetailExtConfiguration>();
            services.AddScoped<WorkerRetailGetStoreBalance, WorkerRetailGetStoreBalance>();
            services.AddScoped<WorkerRetailDocSelesReport, WorkerRetailDocSelesReport>();
            services.AddScoped<WorkerRetailDocSelesReport_NEW, WorkerRetailDocSelesReport_NEW>();

            services.AddScoped<WorkerRetailDocCashierCheck_1Day, WorkerRetailDocCashierCheck_1Day>();
            services.AddScoped<WorkerRetailDocCashierCheck_2Day, WorkerRetailDocCashierCheck_2Day>();
            services.AddScoped<WorkerRetailDocCashierCheck_5Day, WorkerRetailDocCashierCheck_5Day>();
            services.AddScoped<WorkerRetailDocCashierCheck_30Day, WorkerRetailDocCashierCheck_30Day>();
            services.AddScoped<WorkerRetailDocCashierCheck_90Day, WorkerRetailDocCashierCheck_90Day>();

            services.AddScoped<WorkerRetailDocCashierCheck, WorkerRetailDocCashierCheck>();


            services.AddSingleton<SyncRetailDocCashierCheckWorkerByAsyncQueue, SyncRetailDocCashierCheckWorkerByAsyncQueue>();
            services.AddSingleton<SaveRetailDocCashierCheckWorkerByAsyncQueue, SaveRetailDocCashierCheckWorkerByAsyncQueue>();


            services.AddScoped<IRetailEndpointsRepo, RetailEndpointsRepo>();

            services.AddSpaStaticFiles(configuration => {
                configuration.RootPath = "dist/tabakon-web-admin";
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env) {
            serviceScope = app.ApplicationServices.CreateScope();
            //if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            //app.UseHttpsRedirection();

            app.UseRouting();
            
            app.UseCors();

            app.UseAuthorization();

            app.UseStaticFiles();
            app.UseSpaStaticFiles();
            app.UseEndpoints(endpoints => {
                endpoints.MapControllers();
            });


            app.UseSpa(spa => {
                spa.Options.SourcePath = "dist/tabakon-web-admin";
            });



            var saveRetailDocCashierCheckWorkerByAsyncQueue = serviceScope.ServiceProvider.GetService(typeof(SaveRetailDocCashierCheckWorkerByAsyncQueue)) as SaveRetailDocCashierCheckWorkerByAsyncQueue;
        }

    }
}
