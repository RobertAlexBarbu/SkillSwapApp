import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skill_swap/controllers/skills_controller.dart';
import 'package:skill_swap/models/skill.dart';
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

  TextEditingController skillNameTextEditingController = TextEditingController();
  TextEditingController skillDescriptionTextEditingController = TextEditingController();
  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController profileDescriptionTextEditingController = TextEditingController();
  TextEditingController profileAgeTextEditingController = TextEditingController();
  TextEditingController profileNrPhoneTextEditingController = TextEditingController();


  // Predefined categories
  final List<String> categories = ["Art", "Music", "Math", "Science", "Sports", "Technology"];
  // State to keep track of selected categories
  var selectedCategory;
  var skillsController = SkillsController.skillsController;

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
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert, // Three dots icon
              color: Colors.white,
            ),
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (String value) {
              if (value == 'edit') {
                // Handle edit skill logic
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    profileNameTextEditingController.text = name!;
                    profileDescriptionTextEditingController.text = profileHeading!;
                    profileNrPhoneTextEditingController.text= phoneNo!;
                    profileAgeTextEditingController.text = age!;
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade200,
                          title: Center(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile name
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 36,
                                    height: 55,
                                    child: TextFormField(
                                      controller: profileNameTextEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                      decoration: InputDecoration(
                                        constraints: const BoxConstraints(
                                          maxWidth: 360,
                                        ),
                                        filled: true,
                                        fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                                        prefixIcon: Icon(
                                          Icons.title,
                                          color: Colors.orange.shade600,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Description
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 36,
                                    height: 55,
                                    child: TextFormField(
                                      controller: profileDescriptionTextEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                      decoration: InputDecoration(
                                        constraints: const BoxConstraints(
                                          maxWidth: 360,
                                        ),
                                        filled: true,
                                        fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                                        prefixIcon: Icon(
                                          Icons.description,
                                          color: Colors.orange.shade600,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Contact phone nr
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 36,
                                    height: 55,
                                    child: TextFormField(
                                      controller: profileNrPhoneTextEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                      decoration: InputDecoration(
                                        constraints: const BoxConstraints(
                                          maxWidth: 360,
                                        ),
                                        filled: true,
                                        fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.orange.shade600,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Age
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 36,
                                    height: 55,
                                    child: TextFormField(
                                      controller: profileAgeTextEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                      decoration: InputDecoration(
                                        constraints: const BoxConstraints(
                                          maxWidth: 360,
                                        ),
                                        filled: true,
                                        fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                                        prefixIcon: Icon(
                                          Icons.calendar_month,
                                          color: Colors.orange.shade600,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
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
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: ()  {
                            
                                // Close the dialog
                                Navigator.of(context).pop();
                                
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 198, 0, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                          ],
                        );
                      },
                    );
                  },
                );

              } else if (value == 'logout') {
                // Handle delete skill logic
                // Show confirmation dialog for delete
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey.shade200,
                        title: Text(
                          'Confirm Logout', 
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600
                          ),  
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
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
                              FirebaseAuth.instance.signOut();
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
              //edit
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
                        'Edit Profile',
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
              //logout
              PopupMenuItem<String>(
                value: 'logout',
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: 80, // Minimum width of the popup menu
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20), // Icon with custom color and size
                      SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        'Logout',
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            skillNameTextEditingController.text = skill["skillName"];
                                            skillDescriptionTextEditingController.text = skill["skillDescription"];

                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.grey.shade200,
                                                  title: Center(
                                                    child: Text(
                                                      "Edit Skill",
                                                      style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // Skill name
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width - 36,
                                                            height: 55,
                                                            child: TextFormField(
                                                              controller: skillNameTextEditingController,
                                                              textAlignVertical: TextAlignVertical.center,
                                                              style: TextStyle(
                                                                color: Colors.grey.shade600,
                                                              ),
                                                              decoration: InputDecoration(
                                                                constraints: const BoxConstraints(
                                                                  maxWidth: 360,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                                                                prefixIcon: Icon(
                                                                  Icons.title,
                                                                  color: Colors.orange.shade600,
                                                                ),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  borderSide: BorderSide.none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          const SizedBox(height: 30),

                                                          // Description
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width - 36,
                                                            height: 55,
                                                            child: TextFormField(
                                                              controller: skillDescriptionTextEditingController,
                                                              textAlignVertical: TextAlignVertical.center,
                                                              style: TextStyle(
                                                                color: Colors.grey.shade600,
                                                              ),
                                                              decoration: InputDecoration(
                                                                constraints: const BoxConstraints(
                                                                  maxWidth: 360,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                                                                prefixIcon: Icon(
                                                                  Icons.description,
                                                                  color: Colors.orange.shade600,
                                                                ),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  borderSide: BorderSide.none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          const SizedBox(height: 20),

                                                          // Checkbox List for Categories
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "Select skill categories:",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.grey.shade600,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              ...categories.map((skillCategory) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: Row(
                                                                    children: [
                                                                      Radio<String>(
                                                                        value: skillCategory,
                                                                        groupValue: selectedCategory,
                                                                        activeColor: const Color.fromRGBO(255, 198, 0, 1),
                                                                        onChanged: (String? value) {
                                                                          setState(() {
                                                                            selectedCategory = value!; // Update selected category dynamically
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        skillCategory,
                                                                        style: TextStyle(
                                                                          color: Colors.grey.shade600,
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                            ],
                                                          ),

                                                          const SizedBox(height: 30),
                                                        ],
                                                      ),
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
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        try {
                                                          final skillId = skill['id']; // Replace 'id' with the key for the skill's ID

                                                          // await skillsController.updateSkill(
                                                          //   skillId: skillId, // Pass the skill ID
                                                          //   skillName: skillNameTextEditingController.text, // Updated name
                                                          //   skillDescription: skillDescriptionTextEditingController.text, // Updated description
                                                          //   category: selectedCategory ?? "", // Updated category
                                                          // );

                                                          try {
                                                        final currentUser = FirebaseAuth.instance.currentUser;

                                                        if (currentUser == null) {
                                                          throw "No user is currently logged in.";
                                                        }

                                                        var updatedSkill = Skill(
                                                          skillName: skillNameTextEditingController.text,
                                                          skillDescription: skillDescriptionTextEditingController.text,
                                                          category: selectedCategory,
                                                          userId: currentUser.uid,
                                                          id: skillId, // Include the ID of the skill being updated
                                                        );

                                                        // Send PUT request to update skill
                                                        final response = await dio.put(
                                                          'http://10.0.2.2:5165/api/Skill/EditById/$skillId', // Adjust the URL as per your API
                                                          data: updatedSkill.toJson(), // Convert updated skill to JSON
                                                          options: Options(
                                                            headers: {
                                                              'Content-Type': 'application/json',
                                                            },
                                                          ),
                                                        );
                                                      

                                                        if (response.statusCode == 200) {
                                                          // Success response
                                                          print('Skill updated successfully.');
                                                          Get.snackbar(
                                                            'Skill updated successfully.',
                                                            'Updated skill',
                                                            snackPosition: SnackPosition.TOP,
                                                            backgroundColor: Colors.red.shade200,
                                                            colorText: Colors.black,
                                                          );
                                                          
                                                          
                                                        } else {
                                                          throw Exception('Failed to update skill: ${response.statusCode}');
                                                        }
                                                      } catch (error) {
                                                        print('Error updating skill: $error');
                                                        
                                                      }

                                                        
                                                        } catch (error) {
                                                          Get.snackbar(
                                                            'Error',
                                                            'Failed to update skill: $error',
                                                            snackPosition: SnackPosition.BOTTOM,
                                                            backgroundColor: Colors.red.shade200,
                                                            colorText: Colors.black,
                                                          );
                                                        }

                                                      
                                                        // Close the dialog
                                                        Navigator.of(context).pop();
                                                        retrieveSkills();
                                                      },
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(255, 198, 0, 1),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );

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