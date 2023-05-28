using Microsoft.Extensions.DependencyInjection;

namespace RetailClient.Run.ExtConfiguration {
    public static class ExtConfigurationRunnerSericeCollectionExtension {
        public static IServiceCollection AddExtConfigurationRunner(this IServiceCollection services) {
            services.AddScoped<ExtConfigurationRunner>();
            services.AddSingleton<ExtConfigurationRunnerWS>();
            services.AddSingleton<ExtConfigurationRunnerDB>();

            return services;
        }
    }
}
