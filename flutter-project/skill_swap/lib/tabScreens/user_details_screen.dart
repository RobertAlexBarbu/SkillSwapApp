import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skill_swap/controllers/authentication_controller.dart';
import 'package:skill_swap/controllers/profile_controller.dart';
import 'package:skill_swap/controllers/skills_controller.dart';
import 'package:skill_swap/models/person.dart';
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
  var profileController = ProfileController.profileController;
  var authenticationController = AuthenticationController.authController;

  //slider img
  String urlImage1 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";


  retrieveUserInfo() async{
      dio.get("https://skillswapp-api.azurewebsites.net/api/User/GetByUid/${widget.userId}").then((response) {
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
        'https://skillswapp-api.azurewebsites.net/api/Skill/GetAllByUserId/${widget.userId}'

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

  // Function to update profile picture
  Future<void> _updateProfilePicture(String? image) async {
    if (image == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Profile Picture Change"),
        content: const Text("Are you sure you want to change the profile picture?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
       

        final response = await dio.post(
          "http://10.0.2.2:5165/api/User/EditProfileImage/${widget.userId}",
          data: image,
        );

        if (response.statusCode == 200) {
          setState(() {
            imageProfile = response.data["imageProfile"];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated successfully!")),
          );
        } else {
          throw Exception('Failed to update profile picture.');
        }
      } catch (e) {
        print('Error updating profile picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile picture.")),
        );
      }
    }
  }

@override
  void initState() {
    super.initState();
    retrieveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      //app bar

      appBar: AppBar(
       backgroundColor:  theme.scaffoldBackgroundColor,
        title:Text(
          "Profile",
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert, // Three dots icon

            ),

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
                          title: Center(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
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
                                    child: TextField(
                                      controller: profileNameTextEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.title,
                                          color: theme.primaryColor
                                        ),

                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Description
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 36,
                                    height: 55,
                                    child: TextField(
                                      controller: profileDescriptionTextEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Description",
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                            Icons.description,
                                            color: theme.primaryColor
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

                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Phone",
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                            Icons.phone,
                                            color: theme.primaryColor
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

                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Age",
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                            Icons.calendar_month,
                                            color: theme.primaryColor
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async  {
                                await profileController.updateProfile(
                                   profileName:  profileNameTextEditingController.text,
                                   profileDescription: profileDescriptionTextEditingController.text,
                                   profilePhoneNr: profileNrPhoneTextEditingController.text,
                                   age: int.parse(profileAgeTextEditingController.text)
                                );
                                
                                retrieveUserInfo();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(

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
                        title: Text(
                          'Confirm Logout', 
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),  
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(
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
                      Icon(Icons.edit, color:  theme.primaryColor),// Icon with custom color and size
                      SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                      Icon(Icons.logout, color: theme.primaryColor, size: 20), // Icon with custom color and size
                      SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.only(left: 10, right: 10, bottom:20, top: 20),
          child: Column(
            children: [
              //profile picture
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Makes the container a circle
                  border: Border.all(
                    color: theme.primaryColor,
                    width: 2.0,         
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
              SizedBox(height: 20,),      
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                  onPressed: () async
                  {
                    await authenticationController.updateImageFromGalery(context);
                    retrieveUserInfo();
                
                  }, 
                  icon: const Icon(
                    Icons.image_outlined,

                    size: 30,
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      AuthenticationController.authController.updateImageFromPhoneCamera(context);
                      retrieveUserInfo();
                      
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,

                      size: 30,
                    )
                  ),
                ],
              ),
                    
              const SizedBox(height: 20,),
              //user data
              Container(
                padding: const EdgeInsets.all(10),
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

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        phoneNo!,
                        style: TextStyle(
                          fontSize: 14,

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

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          age!,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 10,),

                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills",
                      style:  TextStyle(
                        fontSize: 22,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 22),
              
                     // List of skills
                    skillsList.isEmpty
                    ?  Center(
                        child: Text(
                          "No skills available",
                          style: TextStyle(),
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
                            child:
                          Card(
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child:
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),

                            ),
                            padding: const EdgeInsets.all(6.0),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        skill["skillName"] ?? "Skill Name",
                                        style:  TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  //edit/delete skills
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert, // Three dots icon
                                    ),
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

                                                  title: Center(
                                                    child: Text(
                                                      "Edit Skill",
                                                      style: TextStyle(

                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: Center(
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
                                                                ),
                                                                decoration: InputDecoration(
                                                                  labelText: 'Name',
                                                                  border: OutlineInputBorder(),
                                                                  prefixIcon: Icon(
                                                                    Icons.title,
                                                                    color: theme.primaryColor,

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
                                                                ),
                                                                decoration: InputDecoration(
                                                                  labelText: 'Description',
                                                                  border: OutlineInputBorder(),
                                                                  prefixIcon: Icon(
                                                                    Icons.description,
                                                                    color: theme.primaryColor,

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
                                                                          activeColor: theme.primaryColor,
                                                                          onChanged: (String? value) {
                                                                            setState(() {
                                                                              selectedCategory = value!; // Update selected category dynamically
                                                                            });
                                                                          },
                                                                        ),
                                                                        Text(
                                                                          skillCategory,
                                                                          style: TextStyle(
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
                                                  ),
                                                  actions: [
                                                    //cancel skill update
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration:  BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8),
                                                            ),
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(); // Close the dialog
                                                            },
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 30,),
                                                        //save skill update
                                                        Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration:  BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8),
                                                            ),
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () async {
                                                              final skillId = skill['id']; // Replace 'id' with the key for the skill's ID
                                                              await skillsController.updateSkill(
                                                                skillId: skillId, // Pass the skill ID
                                                                skillName: skillNameTextEditingController.text, // Updated name
                                                                skillDescription: skillDescriptionTextEditingController.text, // Updated description
                                                                category: selectedCategory ?? "", // Updated category
                                                              );
                                                              // Close the dialog
                                                              Navigator.of(context).pop();
                                                              retrieveSkills();
                                                            },
                                                            child: Text(
                                                              'Save',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                                              title: Text(
                                                'Confirm Deletion',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete this skill?',
                                                style: TextStyle(
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
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async{
                                                    final skillId = skill['id'];
                                                    await skillsController.deleteSkill(skillId: skillId);
                                                    Navigator.of(context).pop();
                                                    retrieveSkills();
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
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
                                              Icon(Icons.edit, color:  theme.primaryColor),// Icon with custom color and size
                                              SizedBox(width: 8), // Spacing between icon and text
                                              Text(
                                                'Edit Skill',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
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
                                              Icon(Icons.delete, color: theme.primaryColor, size: 20), // Icon with custom color and size
                                              SizedBox(width: 8), // Spacing between icon and text
                                              Text(
                                                'Delete Skill',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        category != ''
                                            ? category
                                            : 'No category selected',
                                        style:  TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                                size: 30, // Adjust icon size
                              ),
                              splashRadius: 24, // Adjust the tap area radius
                            ),
                          ),
                           Text(
                            "Add new skills",
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