using System.ComponentModel.DataAnnotations;

namespace WebAPI.Domain.Entities;

public class User
{
    [Key]
    public string Uid { get; set; }
    public string Email { get; set; }

    public string ImageProfile { get; set; }
    
    public string Name { get; set; }
    
    public int Age { get; set; }
    
    public string PhoneNo { get; set; }
    
    public string ProfileHeading { get; set; }
    
    public string FCMToken { get; set; }
    
    public long PublishedDateTime { get; set; }
    public List<Skill> Skills = new List<Skill>();
    public List<SkillSwapRequest> CreatedSkillSwapRequests= new List<SkillSwapRequest>();
    public List<SkillSwapRequest> ReceivedSkillSwapRequests= new List<SkillSwapRequest>();
}