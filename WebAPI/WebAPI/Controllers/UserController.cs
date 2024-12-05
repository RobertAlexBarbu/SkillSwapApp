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
    [HttpPost]
    public async Task<ActionResult<UserDto>> CreateAsync(CreateUserDto createUserDto)
    {
        Console.WriteLine("Hello!!!");
        var user = mapper.Map<User>(createUserDto);
        var savedUser = await userService.CreateAsync(user);
        Console.WriteLine(savedUser);
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
            user = await userService.GetByIdAsync(claimsUser.Uid);
        }
        catch (NotFoundException e)
        {
            user = await userService.CreateAsync(claimsUser);
        }

        var userDto = mapper.Map<UserDto>(user);
        return Ok(userDto);
    }
    
}