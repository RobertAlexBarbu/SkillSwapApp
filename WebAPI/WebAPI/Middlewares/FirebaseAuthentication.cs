using WebAPI.Infrastructure.Firebase;

namespace WebAPI.Middlewares;

public class FirebaseAuthentication(RequestDelegate next, FirebaseService firebaseService)
{
    public async Task InvokeAsync(HttpContext context )
    {
        Console.WriteLine("Hello!!! this is Fb mw");
        var authHeader = context.Request.Headers["Authorization"].FirstOrDefault();
        if (authHeader != null && authHeader.StartsWith("Bearer "))
        {
            var token = authHeader.Substring("Bearer ".Length).Trim();
            context.User = await firebaseService.CreateClaimsPrincipalAsync(token);
        }

        await next(context);
    }
}