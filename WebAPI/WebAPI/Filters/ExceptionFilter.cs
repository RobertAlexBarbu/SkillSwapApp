using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using WebAPI.Application.Exceptions;

namespace WebAPI.Filters;

public class ExceptionFilter : IExceptionFilter
{
    public void OnException(ExceptionContext context)
    {
        var e = context.Exception;
        Console.WriteLine(e.Message);
        if (e is NotFoundException)
        {
            context.Result = new NotFoundObjectResult(new { e.Message });
        }
        else if (e is InvalidUserException)
        {
            context.Result = new UnauthorizedObjectResult(new { e.Message });
        }
        else if (e is InvalidClaimsException)
        {
            context.Result = new UnauthorizedObjectResult(new { e.Message });
            ;
        }
        else
        {
            var message = "[ExceptionFilter] " + e.Message;
            context.Result = new BadRequestObjectResult(new { message });
        }
    }
}