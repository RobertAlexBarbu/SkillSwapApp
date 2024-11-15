import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/authentication/register.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';
import 'package:skill_swap/widgets/custom_text_field.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emaiTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  var controllerAuth = AuthenticationController.authController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                "images/logo.png",
                width: 120,
              ),
              const SizedBox(
                height: 30,
              ),
             const Text(
              "Welcome to Skill Swap",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 92, 92, 92)
              ),
             ),
            const SizedBox(
                height: 20,
            ),
            const Text(
              "Please login to your account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 92, 92, 92)
              ),
            ),
            const SizedBox(
                height: 20,
            ), 

            //email
            SizedBox(
              width: MediaQuery.of(context).size.width -36,
              height: 55,
              child: CustomTextField(
                editingController: emaiTextEditingController,
                lableText: "Email",
                iconData: Icons.email_outlined,
                isObsure: false,
              ),
            ),
            
            const SizedBox(
                height: 20,
            ), 

            //password
            SizedBox(
              width: MediaQuery.of(context).size.width -36,
              height: 55,
              child: CustomTextField(
                editingController: passwordTextEditingController,
                lableText: "Password",
                iconData: Icons.lock_open_outlined,
                isObsure: true,
              ),
            ),

            const SizedBox(
                height: 40,
            ), 

            //login button
            Container(
              width: MediaQuery.of(context).size.width -36,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(12)
                )
              ),
              child: InkWell(
                onTap: () async{
                    if(emaiTextEditingController.text.trim().isNotEmpty && passwordTextEditingController.text.trim().isNotEmpty){
                      setState(() {
                        showProgressBar = true;
                      });

                      controllerAuth.loginUser(
                        emaiTextEditingController.text.trim(), 
                        passwordTextEditingController.text.trim());

                      setState(() {
                        showProgressBar = false;
                      });

                    }
                    else{
                        Get.snackbar("Email or password is missing", "Please fill all fields");
                    }
                },
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
              ),
            
            const SizedBox(
                height: 16,
            ), 
            
            //dont have an account / create here button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                InkWell(
                  onTap: () {
                    Get.to(Register());
                  },
                  child: const Text(
                    "Register here",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                )




              ],
            ),

            const SizedBox(
                height: 16,
            ), 

            showProgressBar == true 
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                )
                : Container(),

            const SizedBox(
                height: 16,
            ), 

            
            ],

            
          ),
        ),
      ),
    );
  }
}