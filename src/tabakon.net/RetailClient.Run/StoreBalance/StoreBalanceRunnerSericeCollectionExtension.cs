using Microsoft.Extensions.DependencyInjection;

namespace RetailClient.Run.StoreBalance {
    public static class StoreBalanceRunnerSericeCollectionExtension {
        public static IServiceCollection AddStoreBalanceRunner(this IServiceCollection services) {
            services.AddScoped<StoreBalanceRunner>();
            services.AddSingleton<StoreBalanceRunnerWS>();
            services.AddSingleton<StoreBalanceRunnerDB>();

            return services;
        }
    }
}
