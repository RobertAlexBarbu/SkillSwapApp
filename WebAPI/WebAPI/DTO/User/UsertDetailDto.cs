using WebAPI.DTO.Skill;

namespace WebAPI.DTO.User;

public class UsertDetailDto : UserDto
{
    public List<SkillDto> skills { get; set; }
}