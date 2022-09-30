using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashierCheck_SumCash_SumTerminal : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "SumCash",
                table: "RetailDocCashierCheck",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "SumTerminal",
                table: "RetailDocCashierCheck",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_Date",
                table: "RetailDocCashierCheck",
                column: "Date");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_RetailDocCashierCheck_Date",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "SumCash",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "SumTerminal",
                table: "RetailDocCashierCheck");
        }
    }
}
