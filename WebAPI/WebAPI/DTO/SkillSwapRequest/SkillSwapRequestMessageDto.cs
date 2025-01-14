using WebAPI.DTO.User;

namespace WebAPI.DTO.SkillSwapRequest;

public class SkillSwapRequestMessageDto
{
    public int Id { get; set; }
    public string UserId { get; set; }
    public UserDto User { get; set; }
    public int SkillSwapRequestId { get; set; }
    public DateTime CreatedAt { get; set; } = new DateTime();
    public string Message { get; set; }
}