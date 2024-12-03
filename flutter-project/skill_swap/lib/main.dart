import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/authentication/login.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';
import 'package:skill_swap/controllers/skills_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value){
    Get.put(AuthenticationController());
  });

  Get.put(AuthenticationController());
  Get.put(SkillsController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Skill Swap',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 232, 227, 178)
      ),
      debugShowCheckedModeBanner: false ,
      home: const Login(), 
    );
  }
}
