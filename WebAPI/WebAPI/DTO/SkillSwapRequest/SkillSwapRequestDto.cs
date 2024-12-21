using WebAPI.Domain.Enums;
using WebAPI.DTO.Skill;
using WebAPI.DTO.User;

namespace WebAPI.DTO.SkillSwapRequest;

public class SkillSwapRequestDto
{
    public int Id { get; set; }
    public string RequesterId { get; set; } // User who initiates the request
    public UserDto Requester { get; set; }
    public UserDto Receiver { get; set; }
    public string ReceiverId { get; set; } // User who receives the request
    public int RequestedSkillId { get; set; } // Skill being requested
    public SkillDto RequestedSkill { get; set; }
    public int OfferedSkillId { get; set; } // Skill being requested
    public SkillDto OfferedSkill { get; set; }
    public string Status { get; set; } = SkillSwapRequestStatus.Pending; // "Pending", "Accepted", "Rejected"
    public DateTime CreatedAt { get; set; } = new DateTime();
}