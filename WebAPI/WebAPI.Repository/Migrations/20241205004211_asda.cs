using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebAPI.Repository.Migrations
{
    /// <inheritdoc />
    public partial class asda : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Id",
                table: "Users",
                newName: "Uid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Uid",
                table: "Users",
                newName: "Id");
        }
    }
}
