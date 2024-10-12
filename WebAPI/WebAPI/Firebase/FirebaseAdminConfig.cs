using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;

namespace WebAPI.Firebase;

public class FirebaseAdminConfig
{
    public static void InitializeFirebase()
    {
        var x = FirebaseApp.Create(new AppOptions
        {
            Credential = GoogleCredential.FromFile("./Firebase/firebase.json")
        });
        
    }
}