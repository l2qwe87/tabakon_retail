using Microsoft.Extensions.DependencyInjection;

namespace RetailClient.Run.RetailPing {
    public static class RetailPingRunnerSericeCollectionExtension {
        public static IServiceCollection AddRetailPingRunner(this IServiceCollection services) {
            services.AddScoped<RetailPingRunner>();
            services.AddSingleton<RetailPingerWS>();
            services.AddSingleton<RetailPingerDB>();

            return services;
        }
    }
}
