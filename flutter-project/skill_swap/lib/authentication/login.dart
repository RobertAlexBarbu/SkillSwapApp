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
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              //welcome to skill swap
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600
                    ),
                  ),

                  Text(
                    "to",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                      "Skill ",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600
                        ),
                      ),
                      Text(
                      "Swap",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(255, 198, 0, 1)
                        ),
                      )
                    ],
                  ),
                ]  
              ),
             
              const SizedBox(
                  height: 70,
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
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      prefixIcon:  Icon(Icons.email_outlined,
                          color: Colors.orange.shade600),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
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
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      prefixIcon:  Icon(Icons.lock_open_outlined,
                          color: Colors.orange.shade600),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
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
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 198, 0, 1),
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
                      color: Colors.white,
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