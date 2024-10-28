namespace WebAPI.Domain.Entities;

public class VerificationRequest
{
    public int Id { get; set; }
    public string StudentId { get; set; }
    public string StudentName { get; set; }
    public string UserId { get; set; }
    public User user { get; set; }
}