using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using WebAPI.Application.Services.StudentVerificationService;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.DTO.VerificationRequest;
using WebAPI.Infrastructure.Firebase;

namespace WebAPI.Controllers;

[ApiController]
[Route("/api/[controller]/[action]")]
public class StudentVerificationController(IStudentVerificationService studentVerificationService, IMapper mapper, FirebaseService firebaseService) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult> CreateVerificationRequestAsync(VerificationRequestDto verificationRequestDto)
    {
        var verificationRequest = mapper.Map<VerificationRequest>(verificationRequestDto);
        await studentVerificationService.CreateVerificationRequestAsync(verificationRequest);
        return Ok();
    }
    
    [HttpGet]
    public async Task<ActionResult<List<VerificationRequestDto>>> GetVerificationRequestsAsync()
    {
        var verificationRequests = await studentVerificationService.GetVerificationRequestsAsync();
        var verificationRequestsDto = verificationRequests.Select(mapper.Map<VerificationRequestDto>);
        return Ok(verificationRequestsDto);
    }
    
    [HttpPatch]
    [Route("{id}")]
    public async Task<ActionResult> VerifyAccountAsync(string id)
    {
        await studentVerificationService.VerifyAccountAsync(id);
        await firebaseService.AddRoleClaimAsync(id, Roles.VerifiedUser);
        return Ok();
    }
}