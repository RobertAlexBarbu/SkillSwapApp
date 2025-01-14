namespace WebAPI.DTO.SkillSwapRequest;

public class CreateSkillSwapRequestMessageDto
{
    public string UserId { get; set; }
    public int SkillSwapRequestId { get; set; }
    public string Message { get; set; }
}