using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace WebAPI.Filters;

public class ModelStateFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context)
    {   
        Console.WriteLine(context.ModelState.ValidationState);
        if (!context.ModelState.IsValid)
            context.Result = new BadRequestObjectResult(context.ModelState.ValidationState);
        
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
    }
}