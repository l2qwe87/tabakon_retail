﻿// <auto-generated />
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Tabakon.DBContextMigration;

namespace Tabakon.DALMigration.Migrations
{
    [DbContext(typeof(MigratioTabakonDBContext))]
    [Migration("20200817223938_CreateRetailEndpoint")]
    partial class CreateRetailEndpoint
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "3.1.7")
                .HasAnnotation("Relational:MaxIdentifierLength", 128)
                .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

            modelBuilder.Entity("Tabakon.Entity.RetailEndpoint", b =>
                {
                    b.Property<string>("RetailEndpointIdentity")
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("RetailEndpointHost")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("RetailEndpointName")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("RetailEndpointIdentity");

                    b.ToTable("RetailEndpoint");
                });
#pragma warning restore 612, 618
        }
    }
}