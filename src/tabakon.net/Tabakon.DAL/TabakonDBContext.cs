using System;
using Tabakon.Entity;
using Microsoft.EntityFrameworkCore;

namespace Tabakon.DAL
{
    
    public class TabakonDBContext : DbContext
    {
        //public TabakonDBContext()
        //{
        //}
        public TabakonDBContext(DbContextOptions<TabakonDBContext> options)
            : base(options)
        { }

        public virtual DbSet<RetailEndpoint> RetailEndpoint {get;set;}
        public virtual DbSet<RetailVersion> RetailVersion {get;set;}
        public virtual DbSet<RetailExtConfiguration> RetailExtConfiguration { get; set; }
        public virtual DbSet<RetailPing> RetailPing {get;set;}
        public virtual DbSet<RetailDocSelesReport> RetailDocSelesReport { get; set; }
        public virtual DbSet<RetailGetStoreBalance> RetailGetStoreBalance { get; set; }
        public virtual DbSet<RetailDocCashierCheck> RetailDocCashierCheck { get; set; }

        public virtual DbSet<PaymentDetail> RetailDocCashierCheck_PaymentDetail { get; set; }
        public virtual DbSet<DiscountDetail> RetailDocCashierCheck_DiscountDetail { get; set; }
        public virtual DbSet<GoodsDetail> RetailDocCashierCheck_GoodsDetail { get; set; }



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

            modelBuilder.Entity<RetailExtConfiguration>(m => {
                m.HasKey(a => a.RetailEndpointIdentity);
                m.HasOne(a => a.RetailEndpoint).WithMany().HasForeignKey(f => f.RetailEndpointIdentity);
            });

            modelBuilder.Entity<RetailGetStoreBalance>(m => {
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

            modelBuilder.Entity<RetailDocCashierCheck>(m => {
                m.Property(a => a.Date)
                    .HasColumnType("Date")
                    .HasComputedColumnSql("CAST([DocDate] as Date)");

                m.HasKey(a => new { a.RetailEndpointIdentity, a.DocRef });
                m.HasIndex(a => a.DocRef);
                m.HasIndex(a => a.DocType);
                m.HasIndex(a => new { a.DocDate, a.DocType });
                m.HasIndex(a => a.Date);
                m.HasOne(a => a.RetailEndpoint).WithMany().HasForeignKey(f => f.RetailEndpointIdentity);

                m.HasMany(a => a.PaymentDetail);
                m.Navigation(a => a.PaymentDetail).AutoInclude();
                
                m.HasMany(a => a.DiscountDetail);
                m.Navigation(a => a.DiscountDetail).AutoInclude();
                
                m.HasMany(a => a.GoodsDetail);
                m.Navigation(a => a.GoodsDetail).AutoInclude();

                m.Property(a => a.SumCash).HasDefaultValue(0);
                m.Property(a => a.SumTerminal).HasDefaultValue(0);
            });

            modelBuilder.Entity<PaymentDetail>(m => {
                m.HasKey(a => a.PaymentDetailId );
                m.Property(a => a.PaymentDetailId).HasDefaultValueSql("NEWID()");
            });

            modelBuilder.Entity<DiscountDetail>(m => {
                m.HasKey(a => a.DiscountDetailId);
                m.Property(a => a.DiscountDetailId).HasDefaultValueSql("NEWID()");
            });

            modelBuilder.Entity<GoodsDetail>(m => {
                m.HasKey(a => a.GoodsDetailId);
                m.Property(a => a.GoodsDetailId).HasDefaultValueSql("NEWID()");

                m.Property(a => a.Count).HasDefaultValue(0);
                m.Property(a => a.Price).HasDefaultValue(0);
                m.Property(a => a.Sum).HasDefaultValue(0);
            });

        }
    }
}
