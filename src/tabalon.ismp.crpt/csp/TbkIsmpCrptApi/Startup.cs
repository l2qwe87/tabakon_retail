using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using TbkIsmpContracts;
using TbkIsmpCrpt;
using TbkSigner;
using TbkSignerContracts;

namespace TbkIsmpCrptApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            var appConfig = Configuration.Get<AppConfig>();
            services.AddSingleton(appConfig.IsmpClientConfig);

            services.AddControllers();

            services.AddSingleton<ISigner, BashFrameworkSigner>();
            services.AddSingleton<IIsmpRequestFactory, IsmpRequestFactory>();
            services.AddSingleton<IIsmpClient, IsmpClient>();

            services.AddHttpClient("IsmpClient").ConfigureHttpClient((sp, client) =>
            {
                var ismpClientConfig = sp.GetRequiredService<IsmpClientConfig>();
                if (ismpClientConfig.HttpTimeoutInSeconds != 0)
                {
                    client.Timeout = TimeSpan.FromSeconds(ismpClientConfig.HttpTimeoutInSeconds);
                }
                client.DefaultRequestHeaders.UserAgent.ParseAdd("TabakonIsmpClient/1.0");
            });
            services.AddSingleton<IMarkirovkaAuth, MarkirovkaAuth>();
            services.AddSingleton<IMarkirovkaClient, MarkirovkaClient>();

            services.AddOpenApi();
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            //if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();

                app.UseSwagger();
                app.UseSwaggerUI();
            }

            //app.UseHttpsRedirection();

            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }

    public class AppConfig
    {
        public IsmpClientConfig IsmpClientConfig { get; set; }
    }
}
