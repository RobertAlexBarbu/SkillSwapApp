namespace WebAPI.Domain.Entities;

public class Skill
{
    public String SkillName { get; set; }
    public int Id { get; set; }
    public String Description { get; set; }
    public int SkillCategoryId { get; set; }
    public SkillCategory SkillCategory { get; set; }
}