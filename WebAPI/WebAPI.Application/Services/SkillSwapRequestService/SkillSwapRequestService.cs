using Microsoft.EntityFrameworkCore;
using WebAPI.Application.Exceptions;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.Infrastructure.Firebase;
using WebAPI.Repository.Data;

namespace WebAPI.Application.Services.SkillService;

public class SkillSwapRequestService(AppDbContext context, FirebaseService fb) : ISkillSwapRequestService
{
    public async Task CreateSkillSwapRequestAsync(SkillSwapRequest skillSwapRequest)
    {
        context.SkillSwapRequests.Add(skillSwapRequest);
        await context.SaveChangesAsync();
        var receiver = await context.Users.FirstOrDefaultAsync(u => u.Uid == skillSwapRequest.ReceiverId);
        var requester = await context.Users.FirstOrDefaultAsync(u => u.Uid == skillSwapRequest.RequesterId);
        if (receiver != null && requester != null)
        {
            await fb.SendPushNotificationAsync(receiver.FCMToken, "SkillSwap Request:", $"{requester.Name} wants to swap skills");
        }
        
    }

    public async Task AcceptSkillSwapRequestByIdAsync(int skillSwapRequestId)
    {
        var skillSwapRequest = await context.SkillSwapRequests
            .Include(s => s.Requester)
            .Include(s => s.Receiver)
            .FirstOrDefaultAsync(s => s.Id == skillSwapRequestId);
        if (skillSwapRequest != null)
        {
            skillSwapRequest.Status = SkillSwapRequestStatus.Accepted;
            await context.SaveChangesAsync();
            await fb.SendPushNotificationAsync(skillSwapRequest.Requester.FCMToken, "SkillSwap Request:", $"{skillSwapRequest.Receiver.Name} accepted your skill swap request");
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

    public async Task<List<SkillSwapRequest>> GetAcceptedSkillSwapRequetsByUserId(string userId)
    {
        var skillSwapRequests = await context.SkillSwapRequests.Where(s =>
            (s.RequesterId == userId || s.ReceiverId == userId) && s.Status == SkillSwapRequestStatus.Accepted)
            .Include(s => s.OfferedSkill)
            .Include(s => s.RequestedSkill)
            .Include(s => s.Receiver)
            .Include(s => s.Requester)
            .ToListAsync();
        return skillSwapRequests;
    }
}