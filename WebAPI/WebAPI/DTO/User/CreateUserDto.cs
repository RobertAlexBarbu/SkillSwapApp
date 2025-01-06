namespace WebAPI.DTO.User;

public class CreateUserDto
{
    public string Uid { get; set; }
    public string Email { get; set; }

    public string ImageProfile { get; set; }
    
    public string Name { get; set; }
    
    public int Age { get; set; }
    
    public string PhoneNo { get; set; }
    
    public string ProfileHeading { get; set; }
    
    public string FCMToken { get; set; }
    
    public long PublishedDateTime { get; set; }
}