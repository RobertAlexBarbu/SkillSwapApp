using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using WebAPI.Application.Exceptions;
using WebAPI.Application.Services.SkillService;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.DTO.SkillSwapRequest;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]/[action]")]
public class SkillSwapRequestController(IMapper mapper, ISkillSwapRequestService skillSwapRequestService) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult> CreateSkillSwapRequestAsync(CreateSkillSwapRequestDto createDto)
    {
        var skillSwapRequest = mapper.Map<SkillSwapRequest>(createDto);
        await skillSwapRequestService.CreateSkillSwapRequestAsync(skillSwapRequest);
        return Ok();
    }

    [HttpPost]
    [Route("{id:int}")]
    public async Task<ActionResult> AcceptSkillSwapRequestAsync(int id)
    {
        try
        {
            await skillSwapRequestService.AcceptSkillSwapRequestByIdAsync(id);
            return Ok();
        }
        catch (NotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpPost]
    [Route("{id:int}")]
    public async Task<ActionResult> RejectSkillSwapRequestAsync(int id)
    {
        try
        {
            await skillSwapRequestService.RejectSkillSwapRequestByIdAsync(id);
            return Ok();
        }
        catch (NotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpGet]
    [Route("{userId}")]
    public async Task<ActionResult<List<SkillSwapRequestDto>>> GetReceivedRequestsByUserId(string userId)
    {
        var skillSwapRequests = await skillSwapRequestService.GetReceivedSkillSwapRequestsByUserId(userId);
        var skillSwapRequestDtos = skillSwapRequests.Select(mapper.Map<SkillSwapRequestDto>).ToList();
        return Ok(skillSwapRequestDtos);
    }

    [HttpGet]
    [Route("{userId}")]
    public async Task<ActionResult<List<SkillSwapRequestDto>>> GetCreatedRequestsByUserId(string userId)
    {
        var skillSwapRequests = await skillSwapRequestService.GetCreatedSkillSwapRequestsByUserId(userId);
        var skillSwapRequestDtos = skillSwapRequests.Select(mapper.Map<SkillSwapRequestDto>).ToList();
        return Ok(skillSwapRequestDtos);
    }
    
    
}