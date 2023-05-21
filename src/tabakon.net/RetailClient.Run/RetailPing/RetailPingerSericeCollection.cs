using Microsoft.Extensions.DependencyInjection;

namespace RetailClient.Run.RetailPing {
    public static class RetailPingerSericeCollection {
        public static IServiceCollection AddRetailPinger(this IServiceCollection services) {
            services.AddScoped<RetailPinger>();
            services.AddSingleton<RetailPingerWS>();
            services.AddSingleton<RetailPingerDB>();

            return services;
        }
    }
}
