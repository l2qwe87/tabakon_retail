using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class RetailDocSelesReport_NEW : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailDocSelesReport_NEW",
                columns: table => new
                {
                    RetailEndpointIdentity = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    DocRef = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    LastCheck = table.Column<DateTime>(type: "datetime2", nullable: false),
                    JsonData = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DocDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DocType = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailDocSelesReport_NEW", x => new { x.RetailEndpointIdentity, x.DocRef });
                    table.ForeignKey(
                        name: "FK_RetailDocSelesReport_NEW_RetailEndpoint_RetailEndpointIdentity",
                        column: x => x.RetailEndpointIdentity,
                        principalTable: "RetailEndpoint",
                        principalColumn: "RetailEndpointIdentity",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_NEW_DocDate_DocType",
                table: "RetailDocSelesReport_NEW",
                columns: new[] { "DocDate", "DocType" });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_NEW_DocRef",
                table: "RetailDocSelesReport_NEW",
                column: "DocRef");

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocSelesReport_NEW_DocType",
                table: "RetailDocSelesReport_NEW",
                column: "DocType");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailDocSelesReport_NEW");
        }
    }
}
