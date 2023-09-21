using Microsoft.Extensions.DependencyInjection;
using static RetailClient.Run.RetailDocCashierCheck.RetailDocCashierCheckRunnerWS;

namespace RetailClient.Run.RetailDocCashierCheck {
    public static class RetailDocCashierCheckRunnerSericeCollectionExtension {
        public static IServiceCollection AddRetailDocCashierCheckRunner(this IServiceCollection services) {
            services.AddScoped<RetailDocCashierCheckRunner>();
            services.AddSingleton<RetailDocCashierCheckRunnerWS>();
            services.AddSingleton<RetailDocCashierCheckRunnerDB>();

            return services;
        }
    }
}
