using System;
using Tabakon.DAL;
using Microsoft.EntityFrameworkCore;
using System.IO;
using Microsoft.Extensions.Configuration;

namespace Tabakon.DBContextMigration
{
    public class MigratioTabakonDBContext : TabakonDBContext
    {

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
#if RELEASE
                .AddJsonFile(@"appsettings.Release.json", optional: true, reloadOnChange: true)
#endif
            ;

            IConfiguration configuration = builder.Build();

            optionsBuilder.UseSqlServer(configuration.GetConnectionString("TabakonDataContext"));

        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            using (var ctx = new MigratioTabakonDBContext())
            {
                ctx.Database.Migrate();
            }
            Console.WriteLine("Hello World!");
        }
    }
}
