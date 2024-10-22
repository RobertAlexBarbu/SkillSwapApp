using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using WebAPI.Application.Exceptions;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.Repository.Data;

namespace WebAPI.Application.Services.UserService;

public class UserService(AppDbContext context) : IUserService
{
    public async Task<User> CreateAsync(User user)
    {
        var existingUser = await context.Users.FirstOrDefaultAsync(u => u.Id == user.Id);
        if (existingUser == null)
        {
            context.Users.Add(user);
            await context.SaveChangesAsync();
            return user;
        }

        return existingUser;
    }

    public async Task<User> GetByIdAsync(string id)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) throw new NotFoundException("User");
        return user;
    }

    public async Task<User> ConfigureByIdAsync(string id)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) throw new NotFoundException("User");
        user.Configured = true;
        await context.SaveChangesAsync();
        return user;
    }
    
    public async Task<User> MakeAdminByIdAsync(string id)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) throw new NotFoundException("User");
        user.Role = Roles.Admin;
        await context.SaveChangesAsync();
        return user;
    }

    public User GetFromClaims(ClaimsPrincipal claimIdentity)
    {
        var firebaseUidClaim = claimIdentity.FindFirst(ClaimTypes.NameIdentifier);
        var emailClaim = claimIdentity.FindFirst(ClaimTypes.Email);
        var roleClaim= claimIdentity.FindFirst(ClaimTypes.Role);
        var providerClaim = claimIdentity.FindFirst("provider");
        if (firebaseUidClaim == null || emailClaim == null || providerClaim == null || roleClaim == null)
            // Most likely not Authenticated
            throw new InvalidClaimsException("[UserService.GetFromClaims] Claims are Null");
        return new User
        {
            Id = firebaseUidClaim.Value,
            Email = emailClaim.Value,
            Provider = providerClaim.Value,
            Role = roleClaim.Value
        };
    }
}