using Microsoft.Extensions.DependencyInjection;

namespace RetailClient.Run.RetailDocSelesReport {
    public static class RetailDocSelesReportRunnerSericeCollectionExtension {
        public static IServiceCollection AddRetailDocSelesReportRunner(this IServiceCollection services) {
            services.AddScoped<RetailDocSelesReportRunner>();
            services.AddSingleton<RetailDocSelesReportRunnerWS>();
            services.AddSingleton<RetailDocSelesReportRunnerDB>();

            return services;
        }
    }
}
