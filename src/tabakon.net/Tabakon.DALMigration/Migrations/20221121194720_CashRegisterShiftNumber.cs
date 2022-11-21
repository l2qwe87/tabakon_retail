using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashRegisterShiftNumber : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "CashRegisterShiftNumber",
                table: "RetailDocCashierCheck",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CashRegisterShiftNumber",
                table: "RetailDocCashierCheck");
        }
    }
}
