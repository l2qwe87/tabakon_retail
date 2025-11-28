using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TbkSigner;

namespace TbkIsmpCrptApi
{
    public class Program
    {
    public static void Main(string[] args)
    {
        AppContext.SetSwitch("Microsoft.AspNetCore.Mvc.ApiExplorer.IsEnhancedModelMetadataSupported", true);

        Directory.SetCurrentDirectory(Path.GetDirectoryName(System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName));

        var bash = new BashExecuter();
        var res = bash.Run("subst", "k: c:\\PerfLogs\\k1").Result;

        CreateHostBuilder(args).Build().Run();
    }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .UseWindowsService()
                .ConfigureLogging(logging =>
                {
                    logging.ClearProviders();
                    logging.AddConsole();
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
