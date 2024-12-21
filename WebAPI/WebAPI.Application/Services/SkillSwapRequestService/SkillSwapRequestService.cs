using Microsoft.EntityFrameworkCore;
using WebAPI.Application.Exceptions;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.Repository.Data;

namespace WebAPI.Application.Services.SkillService;

public class SkillSwapRequestService(AppDbContext context) : ISkillSwapRequestService
{
    public async Task CreateSkillSwapRequestAsync(SkillSwapRequest skillSwapRequest)
    {
        context.SkillSwapRequests.Add(skillSwapRequest);
        await context.SaveChangesAsync();
    }

    public async Task AcceptSkillSwapRequestByIdAsync(int skillSwapRequestId)
    {
        var skillSwapRequest = await context.SkillSwapRequests.FirstOrDefaultAsync(s => s.Id == skillSwapRequestId);
        if (skillSwapRequest != null)
        {
            skillSwapRequest.Status = SkillSwapRequestStatus.Accepted;
            await context.SaveChangesAsync();
            return;
        }
        else
        {
            throw new NotFoundException("SkillSwapRequest");
        }
    }

    public async Task RejectSkillSwapRequestByIdAsync(int skillSwapRequestId)
    {
        var skillSwapRequest = await context.SkillSwapRequests.FirstOrDefaultAsync(s => s.Id == skillSwapRequestId);
        if (skillSwapRequest != null)
        {
            skillSwapRequest.Status = SkillSwapRequestStatus.Rejected;
            await context.SaveChangesAsync();
            return;
        }
        else
        {
            throw new NotFoundException("SkillSwapRequest");
        }
    }

    public async Task<List<SkillSwapRequest>> GetReceivedSkillSwapRequestsByUserId(string userId)
    {
        var skillSwapRequests = await context.SkillSwapRequests.Where(s => s.ReceiverId == userId)
            .Include(s => s.OfferedSkill)
            .Include(s => s.RequestedSkill)
            .Include(s => s.Receiver)
            .Include(s => s.Requester)
            .ToListAsync();
        return skillSwapRequests;
    }

    public async Task<List<SkillSwapRequest>> GetCreatedSkillSwapRequestsByUserId(string userId)
    {
        var skillSwapRequests = await context.SkillSwapRequests.Where(s => s.RequesterId == userId)
            .Include(s => s.OfferedSkill)
            .Include(s => s.RequestedSkill)
            .Include(s => s.Receiver)
            .Include(s => s.Requester)
            .ToListAsync();
        return skillSwapRequests;
    }
}