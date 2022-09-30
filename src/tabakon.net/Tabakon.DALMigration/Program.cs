using System;
using Tabakon.DAL;
using Microsoft.EntityFrameworkCore;
using System.IO;
using Microsoft.Extensions.Configuration;

namespace Tabakon.DBContextMigration
{
    public class MigratioTabakonDBContext : TabakonDBContext
    {
        public static IConfiguration GetConfiguration() {
            var builder = new ConfigurationBuilder()
                   .SetBasePath(Directory.GetCurrentDirectory())
                   .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
#if RELEASE
                .AddJsonFile(@"appsettings.Release.json", optional: true, reloadOnChange: true)
#endif
            ;

            return builder.Build();
        }
        internal MigratioTabakonDBContext(DbContextOptions<TabakonDBContext> options)
            : base(options)
        { }

        //public MigratioTabakonDBContext()
        //    : base()
        //{ }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(GetConfiguration().GetConnectionString("TabakonDataContext"));
            //optionsBuilder.UseSqlServer("Data Source=localhost;Initial Catalog=TEST_tabakon;User ID=sa_web;Password=6;Application Name=Tabakon");

        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<TabakonDBContext>();
            optionsBuilder.UseSqlServer(MigratioTabakonDBContext.GetConfiguration().GetConnectionString("TabakonDataContext"));
            using (var ctx = new MigratioTabakonDBContext(optionsBuilder.Options))
            {
                ctx.Database.Migrate();
            }
            Console.WriteLine("Hello World!");
        }
    }


}
