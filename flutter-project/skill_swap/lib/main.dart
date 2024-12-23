import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/authentication/login.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';
import 'package:skill_swap/controllers/skills_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value){
    Get.put(AuthenticationController());
    Get.put(SkillsController());
  });

  await setupFirebaseMessaging();
  //Get.put(AuthenticationController());
  //Get.put(SkillsController());
  
  runApp(const MyApp());
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Get the device's FCM token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message while in the foreground: ${message.notification?.title}');
    // Show notification or update the app state as needed
  });

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.notification?.title}');
  // Show notification or update the app state as needed
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Skill Swap',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false ,
      home: const Login(), 
    );
  }
}
