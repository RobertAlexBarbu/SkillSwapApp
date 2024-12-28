using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using WebAPI.Application.Exceptions;
using WebAPI.Domain.Entities;
using WebAPI.Repository.Data;

namespace WebAPI.Application.Services.UserService;

public class UserService(AppDbContext context) : IUserService
{
    public async Task<User> CreateAsync(User user)
    {
        var existingUser = await context.Users.FirstOrDefaultAsync(u => u.Uid == user.Uid);
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
        var user = await context.Users.Include(u => u.Skills).FirstOrDefaultAsync(u => u.Uid == id);
        if (user == null) throw new NotFoundException("User");
        return user;
    }

    public async Task<List<User>> GetAll()
    {
        var users = await context.Users.ToListAsync();
        return users;
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
            Uid = firebaseUidClaim.Value,
            Email = emailClaim.Value,
        };
    }

    public async Task EditByIdAsync(string id, User user)
    {
        var toBeEdited = await context.Users.FirstOrDefaultAsync(u => u.Uid == id);
        if (toBeEdited != null)
        {
            toBeEdited.Name = user.Name;
            toBeEdited.PhoneNo = user.PhoneNo;
            toBeEdited.ProfileHeading = user.ProfileHeading;
            toBeEdited.Age = user.Age;
            await context.SaveChangesAsync();
            return;
        }
        else
        {
            throw new NotFoundException("User");
        }

    }

    public async Task EditProfileImageAsync(string profileImageValue, string userId)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Uid == userId);
        if (user != null)
        {
            user.ImageProfile = profileImageValue;
            await context.SaveChangesAsync();
            return;
        }
    }
}