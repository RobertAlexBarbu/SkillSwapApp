import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:get/get.dart';
import 'package:skill_swap/tabScreens/addNewSkill.dart';


class UserDetailsScreen extends StatefulWidget {

  String? userId;

  UserDetailsScreen({super.key, this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? uid='';
  String? email='';
  String? password='';
  String? name='';
  String? age='';
  String? phoneNo='';
  String? profileHeading='';
  String? skillList='';
  String? imageProfile='';
  String? publishedDateTime='';


  //slider img
  String urlImage1 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";


  retrieveUserInfo() async{
      FirebaseFirestore.instance.collection("users").doc(widget.userId).get().then((snapshot){
          if(snapshot.exists){
          
            setState(() {
              imageProfile = snapshot.data()!["imageProfile"];
              name = snapshot.data()!["name"];
              age = snapshot.data()!["age"].toString();
              phoneNo = snapshot.data()!["phoneNo"];
              profileHeading = snapshot.data()!["profileHeading"];
             
          
            });
          }
      });
    }


@override
  void initState() {
    super.initState();
    retrieveUserInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //app bar
      appBar: AppBar(
       backgroundColor:  Color.fromRGBO(255, 198, 0, 1),
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
          
              //profile picture
              Container(
                width: MediaQuery.of(context).size.width * 0.4,  // Set the width of the image
                height: MediaQuery.of(context).size.width * 0.4, // Set the height of the image (same as width to make it round)
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Makes the container a circle
                  border: Border.all(
                    color: Colors.white,  // Border color
                    width: 2.0,          // Border width
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageProfile?.isEmpty ?? true ? urlImage1 : imageProfile!,
                    fit: BoxFit.contain,  // Makes sure the whole image is visible without cropping
                    width: double.infinity,  // Ensures the image takes up the full width
                    height: double.infinity, // Ensures the image takes up the full height
                  ),
                ),
              ),             
              
              const SizedBox(height: 30,),
              /*const Divider(
                  color: Colors.white,
                  thickness: 2,
                ),*/
              //user data
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    //name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //phone nr
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                        "Phone Nr.: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        phoneNo!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //age
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Age  ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          age!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10,),
                    //description
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Description: ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profileHeading!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]
                    ),
                    const SizedBox(height: 10,),
                    


                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for aligning the title and the '+' button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Skills",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.to(AddNewSkill());
                            // Add your onPressed logic here
               
                          },
                        ),
                      ],
                    ),
                    // Example list of skills or content
                    const SizedBox(height: 16), // Spacer
                    Container(
                      color: Colors.white.withOpacity(0.2),
                      height: 200,
                      child: Center(
                        child: Text(
                          "Add new skills",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          
            
          

              
            
            ]
          ),
        ),
      )
    );
  }
}