using System;
using Tabakon.Entity;
using Microsoft.EntityFrameworkCore;

namespace Tabakon.DAL
{
    
    public class TabakonDBContext : DbContext
    {
        public TabakonDBContext()
        {   
        }
        public TabakonDBContext(DbContextOptions<TabakonDBContext> options)
            : base(options)
        { }

        public virtual DbSet<RetailEndpoint> RetailEndpoint {get;set;}



        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(@"Server=(localdb)\mssqllocaldb;Database=EFProviders.InMemory;Trusted_Connection=True;ConnectRetryCount=0");
            }
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<RetailEndpoint>(m => {
                m.HasKey(a => a.Identity);
            });
        }
    }
}
