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

namespace RetailClientTests
{
    public class Startup
    {
        private static IServiceScope serviceScope;
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services.AddDbContext<TabakonDBContext>(options => options.UseSqlServer(Configuration.GetConnectionString("TabakonDataContext")));

            services.AddScoped<HttpClientHandler>(serviceProvider =>
            {
                var httpClientHandler = new HttpClientHandler();
                httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => { return true; };
                return httpClientHandler;
            });

            services.AddScoped<HttpClient>(serviceProvider => {
                var httpClientHandler = serviceProvider.GetRequiredService<HttpClientHandler>();
                var httpClient = new HttpClient(httpClientHandler);
                var httpClientTimeout = Configuration.GetValue<double>("HttpClient:Timeout");
                httpClient.Timeout = TimeSpan.FromSeconds(httpClientTimeout);
                return httpClient;
            });


            services.AddSingleton<IJobService, JobService>();
            services.AddScoped<WorkerRetailVersion, WorkerRetailVersion>();
            services.AddScoped<WorkerPing, WorkerPing>();
            services.AddScoped<WorkerRetailExtConfiguration, WorkerRetailExtConfiguration>();
            
            services.AddScoped<WorkerRetailDocSelesReport, WorkerRetailDocSelesReport>();

            services.AddScoped<IRetailEndpointsRepo, RetailEndpointsRepo>(); 

            services.AddSpaStaticFiles(configuration =>
            {
                configuration.RootPath = "dist/tabakon-web-admin";
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            serviceScope = app.ApplicationServices.CreateScope();
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            

            app.UseStaticFiles();
            app.UseSpaStaticFiles();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });


            app.UseSpa(spa =>
            {
                spa.Options.SourcePath = "dist/tabakon-web-admin";
            });

        }



    }
}
