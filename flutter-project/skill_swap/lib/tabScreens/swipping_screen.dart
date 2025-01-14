import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/profile_controller.dart';
import 'package:skill_swap/controllers/skills_controller.dart';
import 'package:skill_swap/main.dart';
import 'package:skill_swap/models/skill.dart';
import 'package:skill_swap/tabScreens/see_user_profile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final theme = Theme.of(context); // Access the theme

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Explore Skills",
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: profileController.allUsersProfileList.length,
          itemBuilder: (context, index) {
            final eachProfileInfo = profileController.allUsersProfileList[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(eachProfileInfo.imageProfile.toString()),
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      // Name and Age
                      Text(
                        "${eachProfileInfo.name}, ${eachProfileInfo.age}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Skill Chips
                      FutureBuilder<List<Skill>>(
                        future: skillsController.fetchSkills(eachProfileInfo.uid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show loading indicator
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              "Error loading skills",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            );
                          }

                          final skills = snapshot.data ?? [];
                          this.skills = skills;
                          eachProfileInfo.skills = skills;

                          if (skills.isNotEmpty) {
                            return Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: [
                                // Display only the first 4 skills
                                ...skills.take(4).map((skill) {
                                  return Chip(
                                    label: Text(skill.skillName ?? "Unnamed Skill"),
                                    backgroundColor: theme.primaryColor,
                                    labelStyle: const TextStyle(color: Colors.white),
                                  );
                                }).toList(),
                                // Add a chip for remaining skills if there are more than 4
                                if (skills.length > 4)
                                  Chip(
                                    label: Text("+${skills.length - 4} more"),
                                    backgroundColor: theme.primaryColor,
                                    labelStyle: const TextStyle(color: Colors.white),
                                  ),
                              ],
                            );
                          } else {
                            return Text(
                              "New to Skill Swap",
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      // See Profile Button
                      ElevatedButton(
                        onPressed: () {
                          Get.to(SeeUserProfile(userProfile: eachProfileInfo));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: theme.hintColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          "See Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
