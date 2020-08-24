using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class RetailDocSelesReport : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailDocSelesReport",
                columns: table => new
                {
                    DocRef = table.Column<string>(nullable: false),
                    DocDate = table.Column<DateTime>(nullable: false),
                    DocType = table.Column<int>(nullable: false),
                    LastCheck = table.Column<DateTime>(nullable: false),
                    RetailEndpointIdentity = table.Column<string>(nullable: true),
                    JsonData = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailDocSelesReport", x => new { x.DocType, x.DocDate, x.DocRef });
                    table.ForeignKey(
                        name: "FK_RetailDocSelesReport_RetailEndpoint_RetailEndpointIdentity",
                        column: x => x.RetailEndpointIdentity,
                        principalTable: "RetailEndpoint",
                        principalColumn: "RetailEndpointIdentity",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_RetailEndpointIdentity",
                table: "RetailDocSelesReport",
                column: "RetailEndpointIdentity");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailDocSelesReport");
        }
    }
}
