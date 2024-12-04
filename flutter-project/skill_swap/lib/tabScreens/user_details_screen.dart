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
// List to store skills
  List<Map<String, dynamic>> skillsList = [];
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
      retrieveSkills();
    }
  // Retrieve skills from the sub-collection
  retrieveSkills() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("skills")
        .get()
        .then((querySnapshot) {
      setState(() {
        skillsList = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
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
          "Profile",
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
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //description
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            profileHeading!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          )
                        )  
                      ]
                    ),
                    const SizedBox(height: 10,),
                    //phone nr
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                        "Contact: ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        phoneNo!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
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
                          "Age:  ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),

                        Text(
                          age!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10,),

                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10,),


                    const SizedBox(height: 16),
              
                     // List of skills
                    skillsList.isEmpty
                    ? const Center(
                        child: Text(
                          "No skills available",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: skillsList.length,
                        itemBuilder: (context, index) {
                          final skill = skillsList[index];
                          final categories = skill["categories"] ?? []; // Retrieve associated categories
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                            padding: const EdgeInsets.all(8.0), 
                            color: Colors.white.withOpacity(0.2),
                            child: ListTile(
                              title: Text(
                                skill["skillName"] ?? "Skill Name",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                  ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [  
                                      Expanded(
                                        child: Text(
                                          skill["skillDescription"] ?? "No Description",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14
                                            ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      )
                                    ],
                                  ),
                                  // Displaying categories
                                  Row(
                                    children: [
                                      const Text(
                                        "Categories: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        categories.isNotEmpty
                                            ? categories.join(', ') // Join categories with commas
                                            : 'No categories selected',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }  
                    ),
                  
                    //add new skills
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16), // Add some padding
                      color: Colors.transparent, 
                      width: 200,// Background for the container
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ensures the column takes up only the space needed
                        children: [
                          Center(
                            child: IconButton(
                              onPressed: () {
                                Get.to(AddNewSkill());
                              },
                              icon: const Icon(
                                Icons.add, // Use the "add" icon
                                color: Colors.white, // Icon color
                                size: 30, // Adjust icon size
                              ),
                              splashRadius: 24, // Adjust the tap area radius
                            ),
                          ),
                          const Text(
                            "Add new skills",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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