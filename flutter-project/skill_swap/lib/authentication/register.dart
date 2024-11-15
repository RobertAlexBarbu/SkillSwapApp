import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';
import 'package:skill_swap/widgets/custom_text_field.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
 //personal info
  TextEditingController emaiTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController skillListTextEditingController = TextEditingController();
  TextEditingController profileHeadinTextEditingController = TextEditingController();
  bool showProgressBar =false; 

  var authenticationController = AuthenticationController.authController;

  // skill list
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),

              
              const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),

              const Text(
                  "to get Started now",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                  ),
                ),

              const SizedBox(
                height: 20,
              ),
               
              authenticationController.imageFile == null?  
              //choose image circle avatar
              const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("images/logo.png"),
                  backgroundColor: Colors.black,
                ) : Container(
                  width:180,
                  height:180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: FileImage(
                        File(
                          authenticationController.imageFile!.path
                        )
                      )
                      )
                  ),
                ), 
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async
                    {
                      await authenticationController.pickImageFileFromGalery();
                      setState(() {
                        authenticationController.imageFile;
                      });

                    }, 
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                      size: 30,
                    )
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  IconButton(
                    onPressed: () async
                    {
                      await authenticationController.captureImageFromPhoneCamera();
                      setState(() {
                        authenticationController.imageFile;
                      });
                    }, 
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                      size: 30,
                    )
                  )
                ],
              ),

              const SizedBox(
                  height: 10,
              ), 
              
              //personal info 
              const Text(
                "Personal Info",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox( 
                  height: 20,
              ), 

              //name
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: nameTextEditingController,
                  lableText: "Name",
                  iconData: Icons.person_outline,
                  isObsure: false,
                  
                )
                 
               
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
                  height: 20,
              ), 

              //age
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: ageTextEditingController,
                  lableText: "Age",
                  iconData: Icons.numbers,
                  isObsure: false,
                ),
              ),
              
              const SizedBox(
                  height: 20,
              ), 

              //phone no
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: phoneTextEditingController,
                  lableText: "Phone",
                  iconData: Icons.phone,
                  isObsure: false,
                ),
              ),
              
              const SizedBox(
                  height: 20,
              ), 

              // profile heading
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: profileHeadinTextEditingController,
                  lableText: "Profile heading",
                  iconData: Icons.text_fields,
                  isObsure: false,
                ),
              ),
              
              const SizedBox(
                  height: 20,
              ), 

              //skill list 
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: skillListTextEditingController,
                  lableText: "Skills",
                  iconData: Icons.face,
                  isObsure: false,
                ),
              ),
              
              const SizedBox(
                  height: 30,
              ), 

              //create account button
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
                onTap: () async {
                  if(authenticationController.imageFile != null){
                      if(nameTextEditingController.text.trim().isNotEmpty &&
                         emaiTextEditingController.text.trim().isNotEmpty &&
                         passwordTextEditingController.text.trim().isNotEmpty &&
                         ageTextEditingController.text.trim().isNotEmpty &&
                         phoneTextEditingController.text.trim().isNotEmpty &&
                         skillListTextEditingController.text.trim().isNotEmpty &&
                         profileHeadinTextEditingController.text.trim().isNotEmpty){
                        
                        setState(() {
                          showProgressBar = true;
                        });
                        
                        await authenticationController.createNewUserAccount(
                          authenticationController.profileImage!, 
                          nameTextEditingController.text.trim(), 
                          ageTextEditingController.text.trim(), 
                          phoneTextEditingController.text.trim(),
                          profileHeadinTextEditingController.text.trim(),
                          skillListTextEditingController.text.trim(),
                          emaiTextEditingController.text.trim(),
                          passwordTextEditingController.text.trim());

                        setState(() {
                          showProgressBar = false ;
                          authenticationController.imageFile = null;
                        });
                        
                      }
                      else{
                        Get.snackbar("A field is empty", "Please fill out all fields");
                      }
                  }
                  else{
                    Get.snackbar("Image file missing", "Please pick an image");
                  }

                },
                child: const Center(
                  child: Text(
                    "Create Account",
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
            
            //already have an account login here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Text(
                    "Login here",
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