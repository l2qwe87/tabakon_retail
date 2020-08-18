using Microsoft.EntityFrameworkCore.Migrations;

namespace Tabakon.DALMigration.Migrations
{
    public partial class CreateRetailEndpoint : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RetailEndpoint",
                columns: table => new
                {
                    RetailEndpointIdentity = table.Column<string>(nullable: false),
                    RetailEndpointName = table.Column<string>(nullable: true),
                    RetailEndpointHost = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RetailEndpoint", x => x.RetailEndpointIdentity);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RetailEndpoint");
        }
    }
}
