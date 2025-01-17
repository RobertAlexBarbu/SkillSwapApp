﻿namespace WebAPI.Domain.Entities;

public class Skill
{
    public String SkillName { get; set; }
    public int Id { get; set; }
    public String SkillDescription { get; set; }
    public String Category { get; set; }
    public string UserId { get; set; }
    public User User { get; set; }
}