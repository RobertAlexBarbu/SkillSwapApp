using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using WebAPI.Application.Services.UserService;
using WebAPI.Domain.Entities;

namespace WebAPI.Filters;

public class AllowRole(string role) :Attribute, IAuthorizationFilter
{
    public void OnAuthorization(AuthorizationFilterContext context)
    {
        // if (context.HttpContext.User?.Identity?.IsAuthenticated != true)
        // {
        //     var message = "[AllowRoleFilter] Principal Not Authenticated";
        //     context.Result = new UnauthorizedObjectResult(new { message });
        // }
        // else
        // {
        //     var userService = context.HttpContext.RequestServices.GetRequiredService<IUserService>();
        //     Console.WriteLine(context.HttpContext.User.FindFirst(ClaimTypes.NameIdentifier));
        //     User user = userService.GetFromClaims(context.HttpContext.User);
        //     if (user.Role != role)
        //     {
        //         var message = $"[AllowRoleFilter] Principal is not {role}";
        //         context.Result = new ObjectResult(new { message})
        //         {
        //             StatusCode = StatusCodes.Status403Forbidden,
        //         };
        //     }
        // }
    }
}