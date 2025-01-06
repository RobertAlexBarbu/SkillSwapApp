using Microsoft.EntityFrameworkCore;
using WebAPI.Application.Exceptions;
using WebAPI.Domain.Entities;
using WebAPI.Repository.Data;

namespace WebAPI.Application.Services.SkillService;

public class SkillService(AppDbContext context): ISkillService
{
    public async Task CreateSkillAsync(Skill skill)
    {
        context.Skills.Add(skill);
        await context.SaveChangesAsync();
        return;
    }

    public async Task DeleteByIdAsync(int id)
    {
        var skill = await context.Skills.FirstOrDefaultAsync(s => s.Id == id);
        if (skill != null)
        {
            context.Skills.Remove(skill);
            await context.SaveChangesAsync();
            return;
        }
        else
        {
            throw new NotFoundException("skill");
        }
    }

    public async Task EditByIdAsync(Skill skill, int id)
    {
        var skillOriginal = await context.Skills.FirstOrDefaultAsync(s => s.Id == id);
        if (skillOriginal != null)
        {
            skillOriginal.SkillName = skill.SkillName;
            skillOriginal.Category = skill.Category;
            skillOriginal.SkillDescription = skill.SkillDescription;
            await context.SaveChangesAsync();
            return;
        }
        else
        {
            throw new NotFoundException("skill");
        }
        
    }

    public async Task<List<Skill>> GetAllByUserIdAsync(string userId)
    {
        var skills = await context.Skills.Where(s => s.UserId == userId).ToListAsync();
        return skills;
    }

    public async Task<Skill> GetById(int id)
    {
        var skill = await context.Skills.FirstOrDefaultAsync(s => s.Id == id);
        if (skill == null)
        {
            throw new NotFoundException("skill");
        }

        return skill;
    }
}