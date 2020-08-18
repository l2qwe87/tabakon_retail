using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CreateRetailPing : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailPing",
                columns: table => new
                {
                    RetailEndpointIdentity = table.Column<string>(nullable: false),
                    LastCheck = table.Column<DateTime>(nullable: false),
                    JsonData = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailPing", x => x.RetailEndpointIdentity);
                    table.ForeignKey(
                        name: "FK_RetailPing_RetailEndpoint_RetailEndpointIdentity",
                        column: x => x.RetailEndpointIdentity,
                        principalTable: "RetailEndpoint",
                        principalColumn: "RetailEndpointIdentity",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailPing");
        }
    }
}
