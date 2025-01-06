using WebAPI.Domain.Enums;

namespace WebAPI.Domain.Entities;

public class SkillSwapRequest
{
    public int Id { get; set; }
    public string RequesterId { get; set; } // User who initiates the request
    public User Requester { get; set; }
    public User Receiver { get; set; }
    public string ReceiverId { get; set; } // User who receives the request
    public int RequestedSkillId { get; set; } // Skill being requested
    public Skill RequestedSkill { get; set; }
    public int OfferedSkillId { get; set; } // Skill being requested
    public Skill OfferedSkill { get; set; }
    public string Status { get; set; } = SkillSwapRequestStatus.Pending; // "Pending", "Accepted", "Rejected"
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}