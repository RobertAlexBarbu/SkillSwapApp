using WebAPI.Domain.Entities;

namespace WebAPI.Application.Services.SkillService;

public interface ISkillSwapRequestService
{
    Task CreateSkillSwapRequestAsync(SkillSwapRequest skillSwapRequest);
    Task AcceptSkillSwapRequestByIdAsync(int skillSwapRequestId);
    Task RejectSkillSwapRequestByIdAsync(int skillSwapRequestId);
    Task<List<SkillSwapRequest>> GetReceivedSkillSwapRequestsByUserId(string userId);
    Task<List<SkillSwapRequest>> GetCreatedSkillSwapRequestsByUserId(string userId);

    Task<List<SkillSwapRequest>> GetAcceptedSkillSwapRequetsByUserId(string userId);

}