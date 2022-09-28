using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashierCheck_Sum_StoreRef : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "StoreRef",
                table: "RetailDocCashierCheck",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "Sum",
                table: "RetailDocCashierCheck",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StoreRef",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "Sum",
                table: "RetailDocCashierCheck");
        }
    }
}
