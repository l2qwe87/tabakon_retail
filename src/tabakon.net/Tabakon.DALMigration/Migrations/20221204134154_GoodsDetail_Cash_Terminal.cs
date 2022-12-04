using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class GoodsDetail_Cash_Terminal : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "SumCash",
                table: "RetailDocCashierCheck_GoodsDetail",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "SumTerminal",
                table: "RetailDocCashierCheck_GoodsDetail",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SumCash",
                table: "RetailDocCashierCheck_GoodsDetail");

            migrationBuilder.DropColumn(
                name: "SumTerminal",
                table: "RetailDocCashierCheck_GoodsDetail");
        }
    }
}
