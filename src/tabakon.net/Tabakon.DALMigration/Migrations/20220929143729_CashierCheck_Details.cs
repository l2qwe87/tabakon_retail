using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CashierCheck_Details : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsSale",
                table: "RetailDocCashierCheck",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Operation",
                table: "RetailDocCashierCheck",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "OwnerFriendlyName",
                table: "RetailDocCashierCheck",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "OwnerRef",
                table: "RetailDocCashierCheck",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SellerFriendlyName",
                table: "RetailDocCashierCheck",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SellerRef",
                table: "RetailDocCashierCheck",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "RetailDocCashierCheck_DiscountDetail",
                columns: table => new
                {
                    DiscountDetailId = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "NEWID()"),
                    Discount = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Sum = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    RetailDocCashierCheckDocRef = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    RetailDocCashierCheckRetailEndpointIdentity = table.Column<string>(type: "nvarchar(450)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailDocCashierCheck_DiscountDetail", x => x.DiscountDetailId);
                    table.ForeignKey(
                        name: "FK_RetailDocCashierCheck_DiscountDetail_RetailDocCashierCheck_RetailDocCashierCheckRetailEndpointIdentity_RetailDocCashierCheck~",
                        columns: x => new { x.RetailDocCashierCheckRetailEndpointIdentity, x.RetailDocCashierCheckDocRef },
                        principalTable: "RetailDocCashierCheck",
                        principalColumns: new[] { "RetailEndpointIdentity", "DocRef" },
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RetailDocCashierCheck_PaymentDetail",
                columns: table => new
                {
                    PaymentDetailId = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "NEWID()"),
                    IsCash = table.Column<bool>(type: "bit", nullable: false),
                    Sum = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    RetailDocCashierCheckDocRef = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    RetailDocCashierCheckRetailEndpointIdentity = table.Column<string>(type: "nvarchar(450)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailDocCashierCheck_PaymentDetail", x => x.PaymentDetailId);
                    table.ForeignKey(
                        name: "FK_RetailDocCashierCheck_PaymentDetail_RetailDocCashierCheck_RetailDocCashierCheckRetailEndpointIdentity_RetailDocCashierCheckD~",
                        columns: x => new { x.RetailDocCashierCheckRetailEndpointIdentity, x.RetailDocCashierCheckDocRef },
                        principalTable: "RetailDocCashierCheck",
                        principalColumns: new[] { "RetailEndpointIdentity", "DocRef" },
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_DiscountDetail_RetailDocCashierCheckRetailEndpointIdentity_RetailDocCashierCheckDocRef",
                table: "RetailDocCashierCheck_DiscountDetail",
                columns: new[] { "RetailDocCashierCheckRetailEndpointIdentity", "RetailDocCashierCheckDocRef" });

            migrationBuilder.CreateIndex(
                name: "IX_RetailDocCashierCheck_PaymentDetail_RetailDocCashierCheckRetailEndpointIdentity_RetailDocCashierCheckDocRef",
                table: "RetailDocCashierCheck_PaymentDetail",
                columns: new[] { "RetailDocCashierCheckRetailEndpointIdentity", "RetailDocCashierCheckDocRef" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailDocCashierCheck_DiscountDetail");

            migrationBuilder.DropTable(
                name: "RetailDocCashierCheck_PaymentDetail");

            migrationBuilder.DropColumn(
                name: "IsSale",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "Operation",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "OwnerFriendlyName",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "OwnerRef",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "SellerFriendlyName",
                table: "RetailDocCashierCheck");

            migrationBuilder.DropColumn(
                name: "SellerRef",
                table: "RetailDocCashierCheck");
        }
    }
}
