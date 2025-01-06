import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/models/person.dart';

import '../interceptors/jwt_interceptor.dart';

class ProfileController extends GetxController{

  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);
  List<Person> get allUsersProfileList => usersProfileList.value;
  final dio = createDio();
  static ProfileController profileController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchProfiles();
  }

  void fetchProfiles() async {
    try {
      // Make a POST request to the API endpoint
      final response = await dio.get("https://skillswapp-api.azurewebsites.net/api/User/GetAll");

      // Extract data from the response
      if (response.statusCode == 200 && response.data is List) {
        List<dynamic> data = response.data;

        // Filter out the current user's profile
        final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
        List<Person> profilesList = data
            .where((user) => user['uid'] != currentUserUid)
            .map((user) => Person.fromJson(user))
            .toList();

        // Update the usersProfileList observable
        usersProfileList.value = profilesList;
      } else {
        throw Exception("Failed to fetch profiles. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching profiles: $e");
      usersProfileList.value = [];
    }
  }



  Future<void> updateProfile({
  required String profileName,
  required String profileDescription,
  required String profilePhoneNr,
  required int age,
}) async{
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser!.uid;
      if (currentUser == null) {
        throw "No user is currently logged in.";
      }

      var updatedProfile = Person(
        name: profileName,
        age: age,
        phoneNo: profilePhoneNr,
        profileHeading: profileDescription,
      );

      // Send PUT request to update profile
      final response = await dio.put(
        'https://skillswapp-api.azurewebsites.net/api/User/EditByUid/$userId', // Adjust the URL as per your API
        data: updatedProfile.toJson(), // Convert updated skill to JSON
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    

      if (response.statusCode == 200) {
        // Success response
        print('Profile updated successfully.');
        Get.snackbar(
          'Profile updated successfully.',
          'Updated profile',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade200,
          colorText: Colors.grey.shade600,
        );
        
        
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
      Get.snackbar(
        'Error',
        'Failed to update profile: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade200,
        colorText: Colors.grey.shade600,
      );
    }

  }
}


