import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:skill_swap/models/person.dart';

import '../interceptors/jwt_interceptor.dart';

class ProfileController extends GetxController{

  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);
  List<Person> get allUsersProfileList => usersProfileList.value;
  final dio = createDio();

  @override
  void onInit() {
    super.onInit();
    fetchProfiles();
  }

  void fetchProfiles() async {
    try {
      // Make a POST request to the API endpoint
      final response = await dio.get("http://10.0.2.2:5165/api/User/GetAll");

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
}


