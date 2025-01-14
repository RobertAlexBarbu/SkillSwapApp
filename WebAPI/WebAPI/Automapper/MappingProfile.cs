using AutoMapper;
using WebAPI.Domain.Entities;
using WebAPI.DTO.Skill;
using WebAPI.DTO.SkillSwapRequest;
using WebAPI.DTO.User;

namespace WebAPI.Automapper;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<User, UserDto>();
        CreateMap<User, UsertDetailDto>();
        CreateMap<User, UsertDetailDto>();
        CreateMap<CreateUserDto, User>();
        CreateMap<EditUserDto, User>();
        
        CreateMap<Skill, SkillDto>();
        CreateMap<CreateSkillDto, Skill>();
        CreateMap<EditSkillDto, Skill>();
        
        CreateMap<SkillSwapRequest, SkillSwapRequestDto>();
        CreateMap<CreateSkillSwapRequestDto, SkillSwapRequest>();

        CreateMap<SkillSwapRequestMessage, SkillSwapRequestMessageDto>();
        CreateMap<CreateSkillSwapRequestMessageDto, SkillSwapRequestMessage>();

    }
}