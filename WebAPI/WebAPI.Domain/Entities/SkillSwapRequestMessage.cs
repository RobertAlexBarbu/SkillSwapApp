namespace WebAPI.Domain.Entities;

public class SkillSwapRequestMessage
{
    public int Id { get; set; }
    public string UserId { get; set; }
    public User User { get; set; }
    public int SkillSwapRequestId { get; set; }
    public SkillSwapRequest SkillSwapRequest { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string Message { get; set; }
}