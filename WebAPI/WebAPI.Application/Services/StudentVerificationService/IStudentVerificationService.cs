using WebAPI.Domain.Entities;

namespace WebAPI.Application.Services.StudentVerificationService;

public interface IStudentVerificationService
{
    Task<List<VerificationRequest>> GetVerificationRequestsAsync();

    Task VerifyAccountAsync(string id);

    Task CreateVerificationRequestAsync(VerificationRequest verificationRequest);
}