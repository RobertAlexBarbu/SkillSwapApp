using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using WebAPI.Application.Exceptions;
using WebAPI.Application.Services.UserService;
using WebAPI.Domain.Entities;
using WebAPI.Domain.Enums;
using WebAPI.DTO.User;
using WebAPI.Filters;
using WebAPI.Infrastructure.Firebase;

namespace WebAPI.Controllers;

[ApiController]
[Route("/api/[controller]/[action]")]
public class UserController(IUserService userService, IMapper mapper, FirebaseService firebaseService) : ControllerBase
{
    // ByToken -> gets necessary data from decoded firebase access token claims
    [HttpPost]
    [AllowAuthenticated]
    public async Task<ActionResult<UserDto>> CreateByTokenAsync()
    {
        var claimsUser = userService.GetFromClaims(User);
        var savedUser = await userService.CreateAsync(claimsUser);
        var userDto = mapper.Map<UserDto>(savedUser);
        return Ok(userDto);
    }
    
    [HttpGet]
    [AllowAuthenticated]
    public async Task<ActionResult> GetByTokenAsync()
    {
        var claimsUser = userService.GetFromClaims(User);
        User user;
        try
        {
            user = await userService.GetByIdAsync(claimsUser.Id);
        }
        catch (NotFoundException e)
        {
            user = await userService.CreateAsync(claimsUser);
        }

        var userDto = mapper.Map<UserDto>(user);
        return Ok(userDto);
    }

    [HttpPatch]
    [AllowAuthenticated]
    public async Task<ActionResult<UserDto>> ConfigureByTokenAsync()
    {
        var claimsUser = userService.GetFromClaims(User);
        var user = await userService.ConfigureByIdAsync(claimsUser.Id);
        var userDto = mapper.Map<UserDto>(user);
        return Ok(userDto);
    }
    
    [HttpPatch]
    [AllowRole(Roles.Admin)]
    [Route("{id}")]
    public async Task<ActionResult<UserDto>> MakeAdminAsync(string id)
    {
        var user = await userService.MakeAdminByIdAsync(id);
        await firebaseService.AddRoleClaimAsync(id, Roles.Admin);
        var userDto = mapper.Map<UserDto>(user);
        return Ok(userDto);
    }
}