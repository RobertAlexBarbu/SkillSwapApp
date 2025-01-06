using System.Security.Claims;
using System.Text;
using System.Text.Json;
using FirebaseAdmin;
using FirebaseAdmin.Auth;
using Google.Apis.Auth.OAuth2;
using System.Net.Http;
using FirebaseAdmin.Messaging;
using Google.Apis.Http;
using WebAPI.Domain.Enums;

namespace WebAPI.Infrastructure.Firebase;

public class FirebaseService
{
    
    private const string FcmUrl = "https://fcm.googleapis.com/fcm/send";

    private readonly HttpClient _httpClient;
    public FirebaseService()
    {
        var x = FirebaseApp.Create(new AppOptions
        {
            Credential = GoogleCredential.FromFile("./firebase.json")
            
        });
        _httpClient = new HttpClient();
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
    
    public async Task SendPushNotificationAsync(string token, string title, string body)
    {
        var message = new Message
        {
            Token = token,  // Device token
            Notification = new Notification
            {
                Title = title,
                Body = body
            },
            // Optional: You can add custom data
            // Data = new Dictionary<string, string>
            // {
            //     { "key1", "value1" },
            //     { "key2", "value2" }
            // }
        };
        var jsonMessage = JsonSerializer.Serialize(message);
        try
        {
            // Send the notification
            var response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
            Console.WriteLine($"Notification sent successfully: {response}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Exception: {ex.Message}");
        }
    }
}