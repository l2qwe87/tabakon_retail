using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class RetailExtConfiguration : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailExtConfiguration",
                columns: table => new
                {
                    RetailEndpointIdentity = table.Column<string>(nullable: false),
                    LastCheck = table.Column<DateTime>(nullable: false),
                    JsonData = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailExtConfiguration", x => x.RetailEndpointIdentity);
                    table.ForeignKey(
                        name: "FK_RetailExtConfiguration_RetailEndpoint_RetailEndpointIdentity",
                        column: x => x.RetailEndpointIdentity,
                        principalTable: "RetailEndpoint",
                        principalColumn: "RetailEndpointIdentity",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailExtConfiguration");
        }
    }
}
