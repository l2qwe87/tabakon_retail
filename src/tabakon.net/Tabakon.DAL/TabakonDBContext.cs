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
        public virtual DbSet<RetailVersion> RetailVersion {get;set;}
        public virtual DbSet<RetailPing> RetailPing {get;set;}
        public virtual DbSet<RetailDocSelesReport> RetailDocSelesReport { get; set; }
        


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
                m.HasKey(a => a.RetailEndpointIdentity);
            });


            modelBuilder.Entity<RetailVersion>(m => {
                m.HasKey(a => a.RetailEndpointIdentity);
                m.HasOne(a => a.RetailEndpoint).WithMany().HasForeignKey(f => f.RetailEndpointIdentity);
            });

            modelBuilder.Entity<RetailPing>(m => {
                m.HasKey(a => a.RetailEndpointIdentity);
                m.HasOne(a => a.RetailEndpoint).WithMany().HasForeignKey(f => f.RetailEndpointIdentity);
            });


            modelBuilder.Entity<RetailDocSelesReport>(m => {
                m.HasKey(a => new { a.RetailEndpointIdentity, a.DocRef });
                m.HasIndex(a => a.DocRef);
                m.HasIndex(a => a.DocType);
                m.HasIndex(a => new { a.DocDate, a.DocType });
                m.HasOne(a => a.RetailEndpoint).WithMany().HasForeignKey(f => f.RetailEndpointIdentity);
            }); 


        }
    }
}
