using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebAPI.Repository.Migrations
{
    /// <inheritdoc />
    public partial class ww : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SkillList",
                table: "Users");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "SkillList",
                table: "Users",
                type: "text",
                nullable: false,
                defaultValue: "");
        }
    }
}
