﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using WebAPI.Repository.Data;

#nullable disable

namespace WebAPI.Repository.Migrations
{
    [DbContext(typeof(AppDbContext))]
    [Migration("20241223131921_fcmtoken")]
    partial class fcmtoken
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("WebAPI.Domain.Entities.Skill", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("Category")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("SkillDescription")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("SkillName")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("UserId");

                    b.ToTable("Skills");
                });

            modelBuilder.Entity("WebAPI.Domain.Entities.SkillSwapRequest", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("timestamp with time zone");

                    b.Property<int>("OfferedSkillId")
                        .HasColumnType("integer");

                    b.Property<string>("ReceiverId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int>("RequestedSkillId")
                        .HasColumnType("integer");

                    b.Property<string>("RequesterId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Status")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("OfferedSkillId");

                    b.HasIndex("ReceiverId");

                    b.HasIndex("RequestedSkillId");

                    b.HasIndex("RequesterId");

                    b.ToTable("SkillSwapRequests");
                });

            modelBuilder.Entity("WebAPI.Domain.Entities.User", b =>
                {
                    b.Property<string>("Uid")
                        .HasColumnType("text");

                    b.Property<int>("Age")
                        .HasColumnType("integer");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("FCMToken")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ImageProfile")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("PhoneNo")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("ProfileHeading")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<long>("PublishedDateTime")
                        .HasColumnType("bigint");

                    b.HasKey("Uid");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("WebAPI.Domain.Entities.Skill", b =>
                {
                    b.HasOne("WebAPI.Domain.Entities.User", "User")
                        .WithMany("Skills")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("WebAPI.Domain.Entities.SkillSwapRequest", b =>
                {
                    b.HasOne("WebAPI.Domain.Entities.Skill", "OfferedSkill")
                        .WithMany()
                        .HasForeignKey("OfferedSkillId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("WebAPI.Domain.Entities.User", "Receiver")
                        .WithMany("ReceivedSkillSwapRequests")
                        .HasForeignKey("ReceiverId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("WebAPI.Domain.Entities.Skill", "RequestedSkill")
                        .WithMany()
                        .HasForeignKey("RequestedSkillId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("WebAPI.Domain.Entities.User", "Requester")
                        .WithMany("CreatedSkillSwapRequests")
                        .HasForeignKey("RequesterId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("OfferedSkill");

                    b.Navigation("Receiver");

                    b.Navigation("RequestedSkill");

                    b.Navigation("Requester");
                });

            modelBuilder.Entity("WebAPI.Domain.Entities.User", b =>
                {
                    b.Navigation("CreatedSkillSwapRequests");

                    b.Navigation("ReceivedSkillSwapRequests");

                    b.Navigation("Skills");
                });
#pragma warning restore 612, 618
        }
    }
}
