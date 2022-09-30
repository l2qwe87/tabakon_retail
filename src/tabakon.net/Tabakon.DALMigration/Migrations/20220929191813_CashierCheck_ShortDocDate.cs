using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashierCheck_ShortDocDate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "Date",
                table: "RetailDocCashierCheck",
                type: "Date",
                nullable: false,
                computedColumnSql: "CAST([DocDate] as Date)");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Date",
                table: "RetailDocCashierCheck");
        }
    }
}
