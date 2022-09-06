using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashierCheck : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailDocCashierCheck",
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
                    table.PrimaryKey("PK_RetailDocCashierCheck", x => new { x.RetailEndpointIdentity, x.DocRef });
                    table.ForeignKey(
                        name: "FK_RetailDocCashierCheck_RetailEndpoint_RetailEndpointIdentity",
                        column: x => x.RetailEndpointIdentity,
                        principalTable: "RetailEndpoint",
                        principalColumn: "RetailEndpointIdentity",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_DocDate_DocType",
                table: "RetailDocCashierCheck",
                columns: new[] { "DocDate", "DocType" });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_DocRef",
                table: "RetailDocCashierCheck",
                column: "DocRef");

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_DocType",
                table: "RetailDocCashierCheck",
                column: "DocType");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailDocCashierCheck");
        }
    }
}
