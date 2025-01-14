import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/authentication/register.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';


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
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 140,
              ),
              //welcome to skill swap
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "Welcome",
                  //   style: TextStyle(
                  //     fontSize: 36,
                  //     fontWeight: FontWeight.w500,
                  //
                  //   ),
                  // ),
                  // Text(
                  //   "to",
                  //   style: TextStyle(
                  //     fontSize: 32,
                  //     fontWeight: FontWeight.w500,
                  //
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child:                   Text(
                      "Welcome to SkillSwap",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryColor
                      ),
                    ),
                  )

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     // Text(
                  //     // "Skill ",
                  //     //   style: TextStyle(
                  //     //     fontSize: 36,
                  //     //     fontWeight: FontWeight.w500,
                  //     //   ),
                  //     // ),
                  //     Text(
                  //     "Welcome to Skill Swap",
                  //       style: TextStyle(
                  //         fontSize: 36,
                  //         fontWeight: FontWeight.w700,
                  //         color: theme.primaryColor
                  //       ),
                  //     )
                  //   ],
                  // ),
                ]  
              ),
             
              const SizedBox(
                  height: 30,
              ),

            //email
            SizedBox(
              width: MediaQuery.of(context).size.width - 96,
              height: 55,
              child: TextFormField(
                  controller: emaiTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(

                  ),
                  decoration: InputDecoration(


                      prefixIcon:  Icon(Icons.email_outlined,
                          color: theme.primaryColor),
                      labelText: 'Email',

                      border: OutlineInputBorder(

                      )),
                ), 
            ),
            
            const SizedBox(
                height: 20,
            ), 

            //password
            SizedBox(
              width: MediaQuery.of(context).size.width -96,
              height: 55,
              child: TextFormField(
                  controller: passwordTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: true,
                  style: TextStyle(

                  ),
                  decoration: InputDecoration(

                      prefixIcon:  Icon(Icons.lock_open_outlined,
                          color: theme.primaryColor),
                      labelText: 'Password',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(

                      )),
                ),
              
            ),

            const SizedBox(
                height: 50,
            ), 

            //login button
            Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                color: theme.primaryColor,
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
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )
              ),
            
            const SizedBox(
                height: 50,
            ), 
            
            //dont have an account / create here button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                InkWell(
                  onTap: () {
                    Get.to(Register());
                  },
                  child: Row(
                    children: [
                      Text(
                        "Register ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600
                        ),
                      ),
                      Text(
                        "here",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                  ],
                  )
                  
                  
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