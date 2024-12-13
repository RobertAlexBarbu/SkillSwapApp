using System.Security.Claims;
using WebAPI.Domain.Entities;

namespace WebAPI.Application.Services.UserService;

public interface IUserService
{
    Task<User> CreateAsync(User user);
    Task<User> GetByIdAsync(string id);

    Task<List<User>> GetAll();
    User GetFromClaims(ClaimsPrincipal claimIdentity);
}