import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/profile_controller.dart';
import 'package:skill_swap/controllers/skills_controller.dart';
import 'package:skill_swap/main.dart';
import 'package:skill_swap/models/skill.dart';
import 'package:skill_swap/tabScreens/see_user_profile.dart';

class SwippingScreen extends StatefulWidget {
  const SwippingScreen({super.key});

  @override
  State<SwippingScreen> createState() => _SwippingScreenState();
}

class _SwippingScreenState extends State<SwippingScreen> {

  ProfileController profileController = Get.put(ProfileController());
  SkillsController skillsController = Get.put(SkillsController());
  List<Skill> skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(255, 198, 0, 1),
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Explore Skills",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx((){
        return Column(
          children: [
            SizedBox(height: 40,),
            Expanded(
              child: ListView.builder(
                itemCount: profileController.allUsersProfileList.length,
                controller: PageController(initialPage: 0, viewportFraction: 0.18),
              
                //scrollDirection: Axis.vertical,

                itemBuilder: (context, index){
                  final eachProfileInfo = profileController.allUsersProfileList[index];

                  return Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                      ),
                  
                      child: Padding(
                        padding:  EdgeInsets.only(left: 15, right: 10, top: 12),
                        child: Column(
                          children: [ 
                            Row(
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 50,  // Width of the circular container
                                    height: 50, // Height of the circular container (same as width for a circle)
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Make the container circular
                                      color: Colors.grey.shade500, // Grey background for the image container
                                    ),
                                    child: ClipOval(
                                      // Ensures the image respects the circular shape
                                      child: Image.network(
                                        eachProfileInfo.imageProfile.toString(),
                                        fit: BoxFit.cover,  // Ensures the image fills the container and covers it fully
                                        alignment: Alignment.topCenter, // Align the image to the top of the container
                                      ),
                                    ),
                                  ),
                                ),


                                SizedBox(
                                  width: 60,
                                ),
                                GestureDetector(
                                  onTap: (){
                                      //eachProfileInfo.skills = skills.where((skill) => skill.userId == eachProfileInfo.uid).toList();
                                      Get.to(SeeUserProfile(userProfile: eachProfileInfo));
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          // //name
                                          Text(
                                            eachProfileInfo.name.toString(),
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          
                                          Text(
                                            ",", 
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                          SizedBox(width: 4),

                                          Text(
                                            eachProfileInfo.age.toString(),
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                        
                                      ]
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            FutureBuilder<List<Skill>>(
                                              future: skillsController.fetchSkills(eachProfileInfo.uid!),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator(); // Show loading indicator
                                                }

                                                if (snapshot.hasError) {
                                                  return Text(
                                                    "Error loading skills",
                                                    style: TextStyle(color: Colors.red, fontSize: 14),
                                                  );
                                                }

                                                final skills = snapshot.data;
                                                this.skills = skills!;
                                                eachProfileInfo.skills = this.skills;
                                                if ( skills.isNotEmpty) {
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      for (var i = 0; i < (skills.length > 1 ? 1 : skills.length); i++)
                                                        Text(
                                                          "• ${skills[i].skillName ?? "Unnamed Skill"}",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade600,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      if (skills.length > 1)
                                                        Text(
                                                          "...",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade600,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                } else {
                                                  return Text(
                                                    "New to Skill Swap",
                                                    style: TextStyle(
                                                      color: Colors.grey.shade600,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                        
                                        
                                        ],
                                      )
                                    ],
                                  ),

                                ),
                              ],
                            ),
                            
                            //filter list icon button
                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(top: 8),
                            //     child: IconButton(
                            //       onPressed: (){

                            //       },
                            //       icon: Icon(
                            //         Icons.filter_list,
                            //         size: 30,
                            //       )
                            //     ),
                            //   ),
                            // ),

                            //name + skills list
                            

                            const SizedBox(
                              height: 14,
                            ),

                          ],
                        ),
                      ),
                    ),
                
                  ); 
                  
                },
              ),
              
            )
          ],
        );
     
      })
    );
  }
}