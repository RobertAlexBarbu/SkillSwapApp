import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/models/skill.dart';

import '../interceptors/jwt_interceptor.dart';

class SkillsController extends GetxController{
  static SkillsController skillsController = Get.find();
  final RxMap<String, List<Skill>> userSkillsMap = <String, List<Skill>>{}.obs;
  final dio = createDio();

  
   
  Future<void> createSkill({
    required String skillName,
    required String skillDescription,
    required String category
  }) 
  async {
    try{
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        throw "No user is currently logged in.";
      }
      var skill = Skill(
        skillName: skillName,
        skillDescription: skillDescription,
        category: category,
        userId: currentUser.uid,
        id: 0
      );
      try {
        final response = await dio.post(
          'https://skillswapp-api.azurewebsites.net/api/Skill/Create',
          data: skill.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Skill added successfully.');
        } else {
          throw Exception('Failed to add skill: ${response.statusCode}');
        }
      } catch (error) {
        print('Error adding skill: $error');
        rethrow; // Re-throw the error for further handling
      }
      // //get skill reference
      // final userSkillsRef = FirebaseFirestore.instance
      //                       .collection("users")
      //                       .doc(currentUser.uid)
      //                       .collection("skills");
      // //add the new skill
      // await userSkillsRef.add({
      //   'skillName': skillName,
      //   'skillDescription': skillDescription,
      //   'categories': categories,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      Get.snackbar(
        "Skill Added",
        "Your skill has been added successfully!",
      );
    } catch (e) {
        Get.snackbar(
        "Error Adding Skill",
        "An error occurred while adding the skill: $e",
      );
    }
  }

  Future<void> updateSkill({
  required int skillId, // Add skillId to identify the skill to update
  required String skillName,
  required String skillDescription,
  required String category,
}) async {
   try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw "No user is currently logged in.";
      }

      var updatedSkill = Skill(
        skillName: skillName,
        skillDescription: skillDescription,
        category: category,
        userId: currentUser.uid,
        id: skillId, // Include the ID of the skill being updated
      );

      // Send PUT request to update skill
      final response = await dio.put(
        'https://skillswapp-api.azurewebsites.net/api/Skill/EditById/$skillId', // Adjust the URL as per your API
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

        );
        
        
      } else {
        throw Exception('Failed to update skill: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating skill: $error');
      Get.snackbar(
        'Error',
        'Failed to update skill: $error',
        snackPosition: SnackPosition.BOTTOM,

      );
    }
}

  Future<void> deleteSkill({
    required int skillId
  }) async {
    try {
                                                       
      final response = await dio.delete(
        'https://skillswapp-api.azurewebsites.net/api/Skill/DeleteById/$skillId', // Update the URL as per your API
      );

      if (response.statusCode == 200) {
        // Successfully deleted
        Get.snackbar(
          'Success',
          'Skill deleted successfully',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw Exception('Failed to delete skill');
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to delete skill: $error',
        snackPosition: SnackPosition.BOTTOM,

      );
    }
  }

  Future<List<Skill>> fetchSkills(String uid) async {
    try {
      print('User ID is $uid');
      final response = await dio.get('https://skillswapp-api.azurewebsites.net/api/Skill/GetAllByUserId/$uid');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Skill.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch skills: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching skills: $error');
      rethrow; // Re-throw the error for further handling
    }
  }
  


   // Get skills for a specific user
  List<Skill> getSkills(String uid) {
    return userSkillsMap[uid] ?? [];
  }

}