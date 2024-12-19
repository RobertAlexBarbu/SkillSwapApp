import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/profile_controller.dart';
import 'package:skill_swap/models/person.dart';

class SeeUserProfile extends StatefulWidget {
  final Person userProfile;

  const SeeUserProfile({super.key, required this.userProfile});

  @override
  _SeeUserProfileState createState() => _SeeUserProfileState();
}

class _SeeUserProfileState extends State<SeeUserProfile> {
  ProfileController profileController = Get.put(ProfileController());
  String _swapStatus = "request"; // Initial status: "request", "requested", "swapping", "declined"
  
  void onRequestTap() {
     setState(() {
      if (_swapStatus == "request") {
        _swapStatus = "requested"; // Change to requested
      } else if (_swapStatus == "requested") {
        _swapStatus = "request"; // Undo the request
      }
    });
  }

  void onResponseReceived(bool accepted) {
    setState(() {
      _swapStatus = accepted ? "swapping" : "declined";
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 198, 0, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Display profile picture
                    ClipOval(
                      child: Image.network(
                        widget.userProfile.imageProfile.toString(),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    SizedBox(height: 20),
                    //name
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          //name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.userProfile.name ?? "Unknown Name",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Swap Button
                              SizedBox(width: 150,),

                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _swapStatus == "request"
                                        ? const Color.fromRGBO(255, 198, 0, 1) // Yellow
                                        : _swapStatus == "requested"
                                            ? Colors.grey // Grey for requested
                                            : _swapStatus == "swapping"
                                                ? Colors.green // Green for swapping
                                                : Colors.red, // Red for declined
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                   child: InkWell(
                                    onTap: _swapStatus == "request" || _swapStatus == "requested"
                                        ? onRequestTap
                                        : null, // Disable tap if not in "request" state
                                    child: Center(
                                      child: Text(
                                        _swapStatus == "request"
                                            ? "Request Swap"
                                            : _swapStatus == "requested"
                                                ? "Swap Requested"
                                                : _swapStatus == "swapping"
                                                    ? "Currently Swapping"
                                                    : "Swap Declined",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
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
                              widget.userProfile.phoneNo ?? "Unknown Contact",
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
                                "Age: ${widget.userProfile.age ?? 'Unknown Age'}",
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
                          widget.userProfile.skills!.isEmpty
                          ?  Center(
                              child: Text(
                                "No skills available",
                                style: TextStyle(color: Colors.grey.shade600),
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
                                            " ${skill.skillName}",
                                            style:  TextStyle(
                                              color: Colors.grey.shade600,
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
                                            " ${skill.category ?? "No Category"}",
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
