namespace WebAPI.Domain.Entities;

public class SkillCategory
{
    public int Id { get; set; }
    public string Name { get; set; }
    public List<Skill> Skills { get; set; }
    
}