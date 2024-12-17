import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skill_swap/tabScreens/addNewSkill.dart';

import '../interceptors/jwt_interceptor.dart';


class UserDetailsScreen extends StatefulWidget {

  String? userId;


  UserDetailsScreen({super.key, this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final dio = createDio();
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
      // FirebaseFirestore.instance.collection("users").doc(widget.userId).get().then((snapshot){
      //     if(snapshot.exists){
      //
      //       setState(() {
      //         imageProfile = snapshot.data()!["imageProfile"];
      //         name = snapshot.data()!["name"];
      //         age = snapshot.data()!["age"].toString();
      //         phoneNo = snapshot.data()!["phoneNo"];
      //         profileHeading = snapshot.data()!["profileHeading"];
      //
      //
      //       });
      //     }
      // });
      dio.get("http://10.0.2.2:5165/api/User/GetByUid/${widget.userId}").then((response) {
        if (response.statusCode == 200 && response.data != null) {
          final userData = response.data;

          setState(() {
            imageProfile = userData["imageProfile"] ?? '';
            name = userData["name"] ?? '';
            age = userData["age"]?.toString() ?? '';
            phoneNo = userData["phoneNo"] ?? '';
            profileHeading = userData["profileHeading"] ?? '';
          });
        } else {
          print("User not found or error occurred");
        }
      }).catchError((error) {
        print("Error fetching user data: $error");
      });
      retrieveSkills();
    }
  // Retrieve skills from the sub-collection
  retrieveSkills() async {
    try {
      final response = await dio.get(
        'http://10.0.2.2:5165/api/Skill/GetAllByUserId/${widget.userId}'

      );

      if (response.statusCode == 200) {
        setState(() {
          skillsList = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        throw Exception('Failed to fetch skills: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching skills: $error');
    }
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
              size: 40,
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
                          final category = skill["category"] ?? "";
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

                                 
                                 PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert, // Three dots icon
                                    color: Colors.grey.shade600,
                                  ),
                                  color: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      // Handle edit skill logic
                                      print('Edit Skill selected');
                                    } else if (value == 'delete') {
                                      // Handle delete skill logic
                                       // Show confirmation dialog for delete
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey.shade200,
                                          title: Text(
                                            'Confirm Deletion', 
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w600
                                            ),  
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this skill?',
                                            style: TextStyle(
                                              color: Colors.grey.shade600
                                            ),  
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async{
                                                // Perform delete logic here
                                                
                                                Navigator.of(context).pop();
                                               
                                                 // Close the dialog
                                                try {
                                                  final skillId = skill['id']; // Replace 'id' with the key for the skill's ID
                                                  final response = await dio.delete(
                                                    'http://10.0.2.2:5165/api/Skill/DeleteById/$skillId', // Update the URL as per your API
                                                  );

                                                  if (response.statusCode == 200) {
                                                    // Successfully deleted
                                                    setState(() {
                                                      skillsList.removeWhere((s) => s['id'] == skillId); // Update the UI
                                                    });
                                                    Get.snackbar(
                                                      'Success',
                                                      'Skill deleted successfully',
                                                      snackPosition: SnackPosition.TOP,
                                                      backgroundColor: Colors.green.shade200,
                                                      colorText: Colors.black,
                                                    );
                                                  } else {
                                                    throw Exception('Failed to delete skill');
                                                  }
                                                } catch (error) {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Failed to delete skill: $error',
                                                    snackPosition: SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red.shade200,
                                                    colorText: Colors.black,
                                                  );
                                                }
                                              },
                                              
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                  color: Colors.red.shade600,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                                ),  
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    }
                                  },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Container(
                                      alignment: Alignment.center,
                                       constraints: BoxConstraints(
                                          minWidth: 80, // Minimum width of the popup menu
                                        ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color:  Color.fromRGBO(255, 198, 0, 1)),// Icon with custom color and size
                                          SizedBox(width: 8), // Spacing between icon and text
                                          Text(
                                            'Edit Skill',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600, // Text color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minWidth: 80, // Minimum width of the popup menu
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red, size: 20), // Icon with custom color and size
                                          SizedBox(width: 8), // Spacing between icon and text
                                          Text(
                                            'Delete Skill',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600, // Text color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                                        "Category: ",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        category != ''
                                          ? category
                                          : 'No category selected',
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
                              onPressed: () async {
                                await Get.to(() => AddNewSkill());
                                retrieveUserInfo();
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