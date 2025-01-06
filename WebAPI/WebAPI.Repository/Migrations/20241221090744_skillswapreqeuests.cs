using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace WebAPI.Repository.Migrations
{
    /// <inheritdoc />
    public partial class skillswapreqeuests : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "SkillSwapRequests",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    RequesterId = table.Column<string>(type: "text", nullable: false),
                    ReceiverId = table.Column<string>(type: "text", nullable: false),
                    RequestedSkillId = table.Column<int>(type: "integer", nullable: false),
                    OfferedSkillId = table.Column<int>(type: "integer", nullable: false),
                    Status = table.Column<string>(type: "text", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SkillSwapRequests", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SkillSwapRequests_Skills_OfferedSkillId",
                        column: x => x.OfferedSkillId,
                        principalTable: "Skills",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_SkillSwapRequests_Skills_RequestedSkillId",
                        column: x => x.RequestedSkillId,
                        principalTable: "Skills",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_SkillSwapRequests_Users_ReceiverId",
                        column: x => x.ReceiverId,
                        principalTable: "Users",
                        principalColumn: "Uid",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_SkillSwapRequests_Users_RequesterId",
                        column: x => x.RequesterId,
                        principalTable: "Users",
                        principalColumn: "Uid",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SkillSwapRequests_OfferedSkillId",
                table: "SkillSwapRequests",
                column: "OfferedSkillId");

            migrationBuilder.CreateIndex(
                name: "IX_SkillSwapRequests_ReceiverId",
                table: "SkillSwapRequests",
                column: "ReceiverId");

            migrationBuilder.CreateIndex(
                name: "IX_SkillSwapRequests_RequestedSkillId",
                table: "SkillSwapRequests",
                column: "RequestedSkillId");

            migrationBuilder.CreateIndex(
                name: "IX_SkillSwapRequests_RequesterId",
                table: "SkillSwapRequests",
                column: "RequesterId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SkillSwapRequests");
        }
    }
}
