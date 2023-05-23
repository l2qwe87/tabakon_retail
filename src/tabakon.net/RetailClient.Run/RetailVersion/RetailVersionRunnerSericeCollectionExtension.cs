using Microsoft.Extensions.DependencyInjection;

namespace RetailClient.Run.RetailVersion {
    public static class RetailVersionRunnerSericeCollectionExtension {
        public static IServiceCollection AddRetailVersionRunner(this IServiceCollection services) {
            services.AddScoped<RetailVersionRunner>();
            services.AddSingleton<RetailVersionRunnerWS>();
            services.AddSingleton<RetailVersionRunnerDB>();

            return services;
        }
    }
}
