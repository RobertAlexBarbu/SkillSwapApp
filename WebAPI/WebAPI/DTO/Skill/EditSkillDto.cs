namespace WebAPI.DTO.Skill;

public class EditSkillDto
{
    public String SkillName { get; set; }
    public int Id { get; set; }
    public String SkillDescription { get; set; }
    public String Category { get; set; }
    public string UserId { get; set; }
}