using Microsoft.EntityFrameworkCore;
using WebAPI.Domain.Entities;

namespace WebAPI.Repository.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
        
    }
    
    public DbSet<User> Users { get; set; }
    public DbSet<Skill> Skills { get; set; }
    
    public DbSet<SkillSwapRequest> SkillSwapRequests { get; set; }
    
    public DbSet<SkillSwapRequestMessage> SkillSwapRequestMessages { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        // User
        modelBuilder.Entity<User>().HasKey(e => e.Uid);
        modelBuilder.Entity<User>()            
            .Property(e => e.Uid)
            .ValueGeneratedNever();
        
        // Skill
        modelBuilder.Entity<Skill>().HasOne(s => s.User).WithMany(u => u.Skills).HasForeignKey(s => s.UserId);
        
        // SkillSwapRequest
        modelBuilder.Entity<SkillSwapRequest>().HasOne(s => s.Requester).WithMany(u => u.CreatedSkillSwapRequests)
            .HasForeignKey(s => s.RequesterId);
        modelBuilder.Entity<SkillSwapRequest>().HasOne(s => s.Receiver).WithMany(u => u.ReceivedSkillSwapRequests)
            .HasForeignKey(s => s.ReceiverId);
        modelBuilder.Entity<SkillSwapRequest>().HasOne(s => s.RequestedSkill).WithMany()
            .HasForeignKey(s => s.RequestedSkillId);
        modelBuilder.Entity<SkillSwapRequest>().HasOne(s => s.OfferedSkill).WithMany()
            .HasForeignKey(s => s.OfferedSkillId);
    }
    
}