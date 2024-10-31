using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebAPI.Repository.Migrations
{
    /// <inheritdoc />
    public partial class SkillCategory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SkillCategoryId",
                table: "Skills",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Skills_SkillCategoryId",
                table: "Skills",
                column: "SkillCategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Skills_SkillCategories_SkillCategoryId",
                table: "Skills",
                column: "SkillCategoryId",
                principalTable: "SkillCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Skills_SkillCategories_SkillCategoryId",
                table: "Skills");

            migrationBuilder.DropIndex(
                name: "IX_Skills_SkillCategoryId",
                table: "Skills");

            migrationBuilder.DropColumn(
                name: "SkillCategoryId",
                table: "Skills");
        }
    }
}
