using WebAPI.Domain.Enums;

namespace WebAPI.DTO.SkillSwapRequest;

public class CreateSkillSwapRequestDto
{
    public string RequesterId { get; set; } // User who initiates the request
    public string ReceiverId { get; set; } // User who receives the request
    public int RequestedSkillId { get; set; } // Skill being requested
    public int OfferedSkillId { get; set; } // Skill being requested
}