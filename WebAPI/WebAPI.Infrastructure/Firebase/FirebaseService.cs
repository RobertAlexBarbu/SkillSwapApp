using System.Security.Claims;
using System.Text.Json;
using FirebaseAdmin;
using FirebaseAdmin.Auth;
using Google.Apis.Auth.OAuth2;
using WebAPI.Domain.Enums;

namespace WebAPI.Infrastructure.Firebase;

public class FirebaseService
{
    public FirebaseService()
    {
        var x = FirebaseApp.Create(new AppOptions
        {
            Credential = GoogleCredential.FromFile("./firebase.json")
        });
    }
    public async Task<ClaimsPrincipal> CreateClaimsPrincipalAsync(string jwtToken)
    {
        var principal = new ClaimsPrincipal(new ClaimsIdentity()); // Unauthenticated Identity
        try
        {
            var decodedToken = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(jwtToken);
            var jsonString = decodedToken.Claims["firebase"].ToString();
            var dictionary = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonString);
            var uid = decodedToken.Uid;
            Console.WriteLine($"Token: {decodedToken}");
        }
        catch (FirebaseAuthException e)
        {
            Console.WriteLine(e.Message);
        }

        return principal;
    }

    public async Task AddRoleClaimAsync(string uid, string role)
    {
        var claims = new Dictionary<string, object>
        {
            { "role", role }
        };
        await FirebaseAuth.DefaultInstance.SetCustomUserClaimsAsync(uid, claims);
    }

    private string? GetUserRoleClaim(FirebaseToken firebaseToken)
    {
        firebaseToken.Claims.TryGetValue("role", out var role);
        return role?.ToString() ?? null;
    }
}