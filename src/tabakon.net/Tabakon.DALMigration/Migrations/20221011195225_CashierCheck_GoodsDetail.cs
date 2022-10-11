using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashierCheck_GoodsDetail : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailDocCashierCheck_GoodsDetail",
                columns: table => new
                {
                    GoodsDetailId = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "NEWID()"),
                    Goods = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Count = table.Column<decimal>(type: "decimal(18,2)", nullable: false, defaultValue: 0m),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false, defaultValue: 0m),
                    Sum = table.Column<decimal>(type: "decimal(18,2)", nullable: false, defaultValue: 0m),
                    RetailDocCashierCheckDocRef = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    RetailDocCashierCheckRetailEndpointIdentity = table.Column<string>(type: "nvarchar(450)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailDocCashierCheck_GoodsDetail", x => x.GoodsDetailId);
                    table.ForeignKey(
                        name: "FK_RetailDocCashierCheck_GoodsDetail_RetailDocCashierCheck_RetailDocCashierCheckRetailEndpointIdentity_RetailDocCashierCheckDoc~",
                        columns: x => new { x.RetailDocCashierCheckRetailEndpointIdentity, x.RetailDocCashierCheckDocRef },
                        principalTable: "RetailDocCashierCheck",
                        principalColumns: new[] { "RetailEndpointIdentity", "DocRef" },
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_GoodsDetail_RetailDocCashierCheckRetailEndpointIdentity_RetailDocCashierCheckDocRef",
                table: "RetailDocCashierCheck_GoodsDetail",
                columns: new[] { "RetailDocCashierCheckRetailEndpointIdentity", "RetailDocCashierCheckDocRef" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailDocCashierCheck_GoodsDetail");
        }
    }
}
