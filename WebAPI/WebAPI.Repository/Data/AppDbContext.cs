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
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.Entity<User>().HasKey(e => e.Uid);
        modelBuilder.Entity<User>()            
            .Property(e => e.Uid)
            .ValueGeneratedNever();
        modelBuilder.Entity<Skill>().HasOne(s => s.User).WithMany(u => u.Skills).HasForeignKey(s => s.UserId);
    }
    
}