﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Tabakon.DBContextMigration;

namespace Tabakon.DALMigration.Migrations
{
    [DbContext(typeof(MigratioTabakonDBContext))]
    [Migration("20220905235928_CashierCheck")]
    partial class CashierCheck
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .UseIdentityColumns()
                .HasAnnotation("Relational:MaxIdentifierLength", 128)
                .HasAnnotation("ProductVersion", "5.0.1");

            modelBuilder.Entity("Tabakon.Entity.RetailDocCashierCheck", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("DocRef")
                        .HasColumnType("nvarchar(450)");

                    b.Property<DateTime>("DocDate")
                        .HasColumnType("datetime2");

                    b.Property<int>("DocType")
                        .HasColumnType("int");

                    b.Property<string>("JsonData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("LastCheck")
                        .HasColumnType("datetime2");

                    b.HasKey("RetailEndpointIdentity", "DocRef");

                    b.HasIndex("DocRef");

                    b.HasIndex("DocType");

                    b.HasIndex("DocDate", "DocType");

                    b.ToTable("RetailDocCashierCheck");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailDocSelesReport", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("DocRef")
                        .HasColumnType("nvarchar(450)");

                    b.Property<DateTime>("DocDate")
                        .HasColumnType("datetime2");

                    b.Property<int>("DocType")
                        .HasColumnType("int");

                    b.Property<string>("JsonData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("LastCheck")
                        .HasColumnType("datetime2");

                    b.HasKey("RetailEndpointIdentity", "DocRef");

                    b.HasIndex("DocRef");

                    b.HasIndex("DocType");

                    b.HasIndex("DocDate", "DocType");

                    b.ToTable("RetailDocSelesReport");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailEndpoint", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<bool>("MarkAsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("RetailEndpointHost")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("RetailEndpointName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("RetailEndpointUrl")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("RetailEndpointIdentity");

                    b.ToTable("RetailEndpoint");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailExtConfiguration", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("JsonData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("LastCheck")
                        .HasColumnType("datetime2");

                    b.HasKey("RetailEndpointIdentity");

                    b.ToTable("RetailExtConfiguration");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailGetStoreBalance", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("JsonData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("LastCheck")
                        .HasColumnType("datetime2");

                    b.HasKey("RetailEndpointIdentity");

                    b.ToTable("RetailGetStoreBalance");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailPing", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("JsonData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("LastCheck")
                        .HasColumnType("datetime2");

                    b.HasKey("RetailEndpointIdentity");

                    b.ToTable("RetailPing");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailVersion", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("JsonData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("LastCheck")
                        .HasColumnType("datetime2");

                    b.HasKey("RetailEndpointIdentity");

                    b.ToTable("RetailVersion");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailDocCashierCheck", b =>
                {
                    b.HasOne("Tabakon.Entity.RetailEndpoint", "RetailEndpoint")
                        .WithMany()
                        .HasForeignKey("RetailEndpointIdentity")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RetailEndpoint");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailDocSelesReport", b =>
                {
                    b.HasOne("Tabakon.Entity.RetailEndpoint", "RetailEndpoint")
                        .WithMany()
                        .HasForeignKey("RetailEndpointIdentity")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RetailEndpoint");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailExtConfiguration", b =>
                {
                    b.HasOne("Tabakon.Entity.RetailEndpoint", "RetailEndpoint")
                        .WithMany()
                        .HasForeignKey("RetailEndpointIdentity")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RetailEndpoint");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailGetStoreBalance", b =>
                {
                    b.HasOne("Tabakon.Entity.RetailEndpoint", "RetailEndpoint")
                        .WithMany()
                        .HasForeignKey("RetailEndpointIdentity")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RetailEndpoint");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailPing", b =>
                {
                    b.HasOne("Tabakon.Entity.RetailEndpoint", "RetailEndpoint")
                        .WithMany()
                        .HasForeignKey("RetailEndpointIdentity")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RetailEndpoint");
                });

            modelBuilder.Entity("Tabakon.Entity.RetailVersion", b =>
                {
                    b.HasOne("Tabakon.Entity.RetailEndpoint", "RetailEndpoint")
                        .WithMany()
                        .HasForeignKey("RetailEndpointIdentity")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RetailEndpoint");
                });
#pragma warning restore 612, 618
        }
    }
}