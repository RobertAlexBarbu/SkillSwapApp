using Microsoft.EntityFrameworkCore;
using WebAPI.Application.Exceptions;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.Repository.Data;

namespace WebAPI.Application.Services.StudentVerificationService;

public class StudentVerificationService(AppDbContext context) : IStudentVerificationService
{
    public async Task<List<VerificationRequest>> GetVerificationRequestsAsync()
    {
        var verificationRequests = await context.VerificationRequests.ToListAsync();
        return verificationRequests;
    }

    public async Task VerifyAccountAsync(string id)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) throw new NotFoundException("User");
        user.Role = Roles.VerifiedUser;
        await context.SaveChangesAsync();
        return;
    }

    public async Task CreateVerificationRequestAsync(VerificationRequest verificationRequest)
    {
        context.VerificationRequests.Add(verificationRequest);
        await context.SaveChangesAsync();
        return;

    }
    
    
}