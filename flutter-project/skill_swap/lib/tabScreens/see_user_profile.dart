import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/profile_controller.dart';
import 'package:skill_swap/interceptors/jwt_interceptor.dart';
import 'package:skill_swap/models/Status.dart';
import 'package:skill_swap/models/notifications.dart';
import 'package:skill_swap/models/person.dart';
import 'package:skill_swap/models/swap_request.dart';

class SeeUserProfile extends StatefulWidget {
  final Person userProfile;

  const SeeUserProfile({super.key, required this.userProfile});

  @override
  _SeeUserProfileState createState() => _SeeUserProfileState();
}

class _SeeUserProfileState extends State<SeeUserProfile> {

  ProfileController profileController = Get.put(ProfileController());
  Status _swapStatus = Status.request;
  final dio = createDio();
  int? _selectedUserSkillId;
  int? _selectedMySkillId;
  List<Map<String, dynamic>> skillsList = [];

    @override
  void initState() {
    super.initState();
    retrieveSkills();
  }


  void onRequestTap() async {
  if (_selectedMySkillId == null || _selectedUserSkillId == null) {
    Get.snackbar(
      "Error",
      "Please select skills for both you and the user.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  setState(() {
    _swapStatus = Status.requested;
  });

  final url = 'https://skillswapp-api.azurewebsites.net/SkillSwapRequest/CreateSkillSwapRequest';
  final dio = createDio();

  try {
    final response = await dio.post(url, data: {
      "requesterId": FirebaseAuth.instance.currentUser?.uid, // Current user ID
      "receiverId": widget.userProfile.uid, // Target user's ID
      "requestedSkillId": _selectedUserSkillId,
      "offeredSkillId": _selectedMySkillId,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Skill swap request created successfully.");
      Get.snackbar(
        "Success",
        "Skill swap request sent!",

      );
    } else {
      throw Exception("Failed to create request. Server responded with ${response.statusCode}.");
    }
  } catch (e) {
    print("Error creating skill swap request: $e");
    setState(() {
      _swapStatus = Status.request; // Revert status on error
    });
    Get.snackbar(
      "Error",
      "Could not send the request. Please try again later.",
      colorText: Colors.white,
    );
  }
}

  void onResponseReceived(bool accepted) {
    setState(() {
      _swapStatus = accepted ? Status.swapping : Status.declined;
    });
  }

  retrieveSkills() async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      final response = await dio.get(
        'https://skillswapp-api.azurewebsites.net/api/Skill/GetAllByUserId/$id'
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

void _showCreateSwapDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners for the dialog
        ),

        title: Text(
          'Create Swap Request',
          style: TextStyle(
            fontSize: 22, // Increase the font size of the title
            fontWeight: FontWeight.bold,

          ),
        ),
        contentPadding: EdgeInsets.all(20), // Padding inside the dialog
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: 400, // Set a custom width for the dialog
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Authenticated user's skills
                  Text(
                    "Your Skills (to offer):",
                    style: TextStyle(
                      fontSize: 18, // Increase the font size
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  // Dropdown for your skills to offer
                  DropdownButton<int>(
                    value: _selectedMySkillId,
                    hint: Text(
                      _selectedMySkillId == null
                          ? "Choose a skill to offer"
                          : skillsList.firstWhere((skill) => skill['id'] == _selectedMySkillId)['skillName'],
                      style: TextStyle(
                        fontSize: 16, // Font size for the hint

                      ),
                    ),
                    items: skillsList.map((skill) {
                      return DropdownMenuItem<int>(
                        value: skill['id'],
                        child: Text(
                          skill['skillName'],  // Show the skill name in the dropdown
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMySkillId = value;  // Update the selected skill for offering
                      });
                    },
                    isExpanded: true, // Expand the dropdown to fill width
                    icon: Icon(
                      Icons.arrow_drop_down, // Dropdown icon

                    ),

                    style: TextStyle( // Text style for the button

                      fontSize: 16,
                    ),
                    underline: Container(), // Remove the underline
                  ),

                  SizedBox(height: 20),

                  // Viewed user's skills (to request)
                  Text(
                    "${widget.userProfile.name}'s Skills (to request):",
                    style: TextStyle(
                      fontSize: 18, // Increase the font size
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  DropdownButton<int>(
                    value: _selectedUserSkillId,  // This will ensure the dropdown reflects the current selected value
                    hint: Text(
                      _selectedUserSkillId == null
                          ? "Choose a skill to request"
                          : widget.userProfile.skills!.firstWhere((skill) => skill.id == _selectedUserSkillId).skillName!,
                      style: TextStyle(
                        fontSize: 16, // Font size for the hint

                      ),
                    ),
                    items: widget.userProfile.skills!.map((skill) {
                      return DropdownMenuItem<int>(
                        value: skill.id,
                        child: Text(
                          skill.skillName!,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserSkillId = value;  // Trigger a rebuild and update the state inside the dialog
                      });
                    },
                    isExpanded: true, // Expand the dropdown to fill width
                    icon: Icon(
                      Icons.arrow_drop_down, // Dropdown icon

                    ),

                    style: TextStyle( // Text style for the button

                      fontSize: 16,
                    ),
                    underline: Container(), // Remove the underline
                  ),
                ],
              ),
            );
          },
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding for actions
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedUserSkillId = null; // Reset the selected skill to null when canceling
                _selectedMySkillId = null;
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onRequestTap(); // Call the function when submitting
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25), // Padding for button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded button corners
              ),
              textStyle: TextStyle(
                fontSize: 16, // Font size for button text
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    // Display profile picture
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.primaryColor,  // Border color
                          width: 4.0,          // Border width
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.userProfile.imageProfile.toString(),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //name
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                           Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                ElevatedButton(
                                  onPressed: () => _showCreateSwapDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // Rounded corners
                                    ),
                                  ),
                                  child: Text(
                                    "Create Swap Request",
                                    style: TextStyle(
                                      fontSize: 16, // Font size
                                      fontWeight: FontWeight.bold, // Font weight
                                      color: Colors.white
                                    ),
                                  ),
                                )
                              ],
                            ),

                          //name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.userProfile.name ?? "Unknown Name",
                                style: TextStyle(
                                  fontSize: 20,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                  widget.userProfile.profileHeading ?? "Unknown Description",
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
                              widget.userProfile.phoneNo ?? "Unknown Contact",
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
                                "Age: ${widget.userProfile.age ?? 'Unknown Age'}",
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
                      padding: const EdgeInsets.all(20),
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
                          widget.userProfile.skills!.isEmpty
                          ?  Center(
                              child: Text(
                                "No skills available",
                                style: TextStyle(),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:  widget.userProfile.skills!.length,
                              itemBuilder: (context, index) {
                                final skill =  widget.userProfile.skills![index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child:
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    child:                                   Container(

                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),

                                      ),
                                      padding: const EdgeInsets.all(6.0),
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  " ${skill.skillName}",
                                                  style:  TextStyle(

                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  overflow: TextOverflow.ellipsis
                                              ),
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
                                                    " ${skill.skillDescription}",
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
                                                  "Categories: ",
                                                  style: TextStyle(

                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Text(
                                                  " ${skill.category ?? "No Category"}",
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
                                  )

                              );
                      }
                    ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
