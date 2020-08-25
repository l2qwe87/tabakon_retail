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
                    RetailEndpointIdentity = table.Column<string>(nullable: false),
                    DocRef = table.Column<string>(nullable: false),
                    LastCheck = table.Column<DateTime>(nullable: false),
                    JsonData = table.Column<string>(nullable: true),
                    DocDate = table.Column<DateTime>(nullable: false),
                    DocType = table.Column<int>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailDocSelesReport", x => new { x.RetailEndpointIdentity, x.DocRef });
                    table.ForeignKey(
                        name: "FK_RetailDocSelesReport_RetailEndpoint_RetailEndpointIdentity",
                        column: x => x.RetailEndpointIdentity,
                        principalTable: "RetailEndpoint",
                        principalColumn: "RetailEndpointIdentity",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_DocRef",
                table: "RetailDocSelesReport",
                column: "DocRef");

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_DocType",
                table: "RetailDocSelesReport",
                column: "DocType");

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_DocDate_DocType",
                table: "RetailDocSelesReport",
                columns: new[] { "DocDate", "DocType" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailDocSelesReport");
        }
    }
}
