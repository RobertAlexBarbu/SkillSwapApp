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
            fontWeight: FontWeight.w600,
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
                  shape: BoxShape.circle,
                  // Makes the container a circle
                  border: Border.all(
                    color:Colors.grey.shade600,  // Border color
                    width: 2.0,          // Border width
                  ),
                  /*boxShadow: [
                      BoxShadow(
                      color: Colors.grey.shade100,
                      spreadRadius: 8.0,
                      blurRadius: 2.0,
                      offset: Offset(3, 3)
                    )
                  ],*/ 
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
                            color: Colors.grey.shade600,
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
                              color: Colors.grey.shade600,
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
                         Text(
                        "Contact: ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        phoneNo!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
                         Text(
                          "Age:  ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          age!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
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
                      style:  TextStyle(
                        fontSize: 22,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 22),
              
                     // List of skills
                    skillsList.isEmpty
                    ?  Center(
                        child: Text(
                          "No skills available",
                          style: TextStyle(color: Colors.grey.shade600),
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
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.all(6.0), 
                              child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      skill["skillName"] ?? "Skill Name",
                                      style:  TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                        ),
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),

                                  //Spacer(flex: 1,),

                                  /*Row(
                                    children: [
                                      //edit button
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: (){
                                          //
                                        },
                                      ),
                                        //delete button
                                      IconButton(
                                        icon:const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: (){
                                          //
                                        }
                                      )
                                    ],
                                  ),*/
                                  IconButton(
                                  icon:  Icon(
                                    Icons.more_vert, // Three dots icon
                                    color: Colors.grey.shade600,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    // Handle more options logic
                                  },
                                ),
                  
                                ],
                              ),

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [  
                                      Expanded(
                                        child: Text(
                                          skill["skillDescription"] ?? "No Description",
                                          style:  TextStyle(
                                            color: Colors.grey.shade600,
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
                                       Text(
                                        "Categories: ",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        categories.isNotEmpty
                                            ? categories.join(', ') // Join categories with commas
                                            : 'No categories selected',
                                        style:  TextStyle(
                                          color: Colors.grey.shade600,
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
                      padding: const EdgeInsets.all(4.0), // Add some padding
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
                              icon:  Icon(
                                Icons.add, // Use the "add" icon
                                color: Colors.grey.shade500, // Icon color
                                size: 30, // Adjust icon size
                              ),
                              splashRadius: 24, // Adjust the tap area radius
                            ),
                          ),
                           Text(
                            "Add new skills",
                            style: TextStyle(color: Colors.grey.shade600),
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