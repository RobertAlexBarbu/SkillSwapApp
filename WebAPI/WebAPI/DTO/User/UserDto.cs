namespace WebAPI.DTO.User;

public class UserDto
{
    public string Uid { get; set; }
    public string Email { get; set; }

    public DateTime CreatedAt { get; set; }

    public string Provider { get; set; }
    
    public string Role { get; set; }
    
    public bool Configured { get; set; }
}