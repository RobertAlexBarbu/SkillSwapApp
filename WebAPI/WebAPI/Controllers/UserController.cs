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
    [Route("{id}")]
    public async Task<ActionResult> GetByUidAsync(string id)
    {
        var user = await userService.GetByIdAsync(id);
        var userDto = mapper.Map<UserDto>(user);
        return Ok(userDto);
    }

    [HttpGet]
    public async Task<ActionResult<List<UserDto>>> GetAllAsync()
    {
        var users = await userService.GetAll();
        return Ok(users.Select(mapper.Map<UserDto>));
    }

    [HttpPut]
    [Route("{id}")]
    public async Task<ActionResult> EditByUidAsync(string id, EditUserDto editUserDto)
    {
        var user = mapper.Map<User>(editUserDto);
        await userService.EditByIdAsync(id, user);
        return Ok();
    }
    
    [HttpPut]
    [Route("{id}")]
    public async Task<ActionResult> EditProfileImageAsync(string id, EditProfileImageDto editProfileImageDto)
    {
        await userService.EditProfileImageAsync( editProfileImageDto.NewProfileImageUrl, id);
        return Ok();
    }
    
}