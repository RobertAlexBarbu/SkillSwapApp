import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';


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
                height: 120,
              ),

              authenticationController.imageFile == null?  
              //choose image circle avatar
              const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("images/profile.png"),
                ) : Container(
                  width:60,
                  height:60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(
                          authenticationController.imageFile!.path
                        )
                      )
                      )
                  ),
                ), 
              
              SizedBox(
                height: 10,
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
                  height: 30,
              ), 
              
              //name
              SizedBox(
                width: MediaQuery.of(context).size.width - 96,
                height: 55,
                child: TextFormField(
                  controller: nameTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      prefixIcon:  Icon(Icons.person_outline,
                          color: Colors.orange.shade600),
                      hintText: 'Name',
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
                  height: 10,
              ), 

              //email
              SizedBox(
                width: MediaQuery.of(context).size.width - 96,
                height: 55,
                child: TextFormField(
                  controller: emaiTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
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
                  height: 10,
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
                  height: 10,
              ), 

              //age
              SizedBox(
                width: MediaQuery.of(context).size.width -96,
                height: 55,
                child: TextFormField(
                  controller: ageTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      prefixIcon:  Icon(Icons.calendar_month,
                          color: Colors.orange.shade600),
                      hintText: 'Age',
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
                  height: 10,
              ), 

              //phone no
              SizedBox(
                width: MediaQuery.of(context).size.width -96,
                height: 55,
                child: TextFormField(
                  controller: phoneTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      prefixIcon:  Icon(Icons.phone,
                          color: Colors.orange.shade600),
                      hintText: 'Phone Number',
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
                  height: 10,
              ), 

              // profile heading
              SizedBox(
                width: MediaQuery.of(context).size.width -96,
                height: 55,
                child: TextFormField(
                  controller: profileHeadinTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      prefixIcon:  Icon(Icons.edit,
                          color: Colors.orange.shade600),
                      hintText: 'Description of you',
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

              //create account button
              Container(
                width: 180,
                height: 50,
                decoration:  BoxDecoration(
                  color: Colors.orange.shade600,
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
            
            //already have an account login here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Text(
                        "Login ",
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
                height: 26,
            ), 
           
            ],
          ),
        ),
      ),
    );
  }
}