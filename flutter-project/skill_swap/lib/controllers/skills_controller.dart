import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        skillDescription: skillName,
        category: category,
        userId: currentUser.uid,
        id: 0
      );
      try {
        final response = await dio.post(
          'http://10.0.2.2:5165/api/Skill/Create',
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

  Future<List<Skill>> fetchSkills(String uid) async {
    try {
      print('User ID is $uid');
      final response = await dio.get('http://10.0.2.2:5165/api/Skill/GetAllByUserId/$uid');

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