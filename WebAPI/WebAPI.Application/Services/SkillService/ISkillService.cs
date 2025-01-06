using WebAPI.Domain.Entities;

namespace WebAPI.Application.Services.SkillService;

public interface ISkillService
{ 
    Task CreateSkillAsync(Skill skill);
    Task DeleteByIdAsync(int id);
    Task EditByIdAsync(Skill skill, int id);

    Task<List<Skill>> GetAllByUserIdAsync(string userId);

    Task<Skill> GetById(int id);

}