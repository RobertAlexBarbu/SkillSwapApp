import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SkillsController extends GetxController{
  static SkillsController skillsController = Get.find();

  Future<void> createSkill({
    required String skillName,
    required String skillDescription,
    required List<String> categories,
  }) 
  async {
    try{
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        throw "No user is currently logged in.";
      }

      //get skill reference
      final userSkillsRef = FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser.uid)
                            .collection("skills");
      //add the new skill
      await userSkillsRef.add({
        'skillName': skillName,
        'skillDescription': skillDescription,
        'categories': categories,
        'createdAt': FieldValue.serverTimestamp(),
      });

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
}