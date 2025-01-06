using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using WebAPI.Application.Services.SkillService;
using WebAPI.Domain.Entities;
using WebAPI.DTO.Skill;

namespace WebAPI.Controllers;

[ApiController]
[Route("/api/[controller]/[action]")]
public class SkillController(ISkillService skillService, IMapper mapper) : ControllerBase
{
    
    [HttpPost]
    public async Task<ActionResult> CreateAsync(CreateSkillDto createSkillDto)
    {

        Console.WriteLine("Creating new skill!");
        var skill = mapper.Map<Skill>(createSkillDto);
        await skillService.CreateSkillAsync(skill);
        return Ok();
    }
    
    [HttpDelete]
    [Route("{id:int}")]
    public async Task<ActionResult> DeleteByIdAsync(int id)
    {
        await skillService.DeleteByIdAsync(id);
        return Ok();
    }
    
    [HttpPut]
    [Route("{id}")]
    public async Task<ActionResult> EditByIdAsync(int id, EditSkillDto editSkillDto)
    {
        var skill = mapper.Map<Skill>(editSkillDto);
        await skillService.EditByIdAsync(skill, id);
        return Ok();
    }

    [HttpGet]
    [Route("{id}")]
    public async Task<ActionResult<SkillDto>> GetById(int id)
    {
        var skill = await skillService.GetById(id);
        return mapper.Map<SkillDto>(skill);
    }
    
    [HttpGet]
    [Route("{id}")]
    public async Task<ActionResult<List<SkillDto>>> GetAllByUserId(string id)
    {
        var skills = await skillService.GetAllByUserIdAsync(id);
        return Ok(skills.Select(mapper.Map<SkillDto>));
    }
}