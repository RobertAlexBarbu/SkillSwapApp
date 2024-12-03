import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:skill_swap/models/person.dart';

class ProfileController extends GetxController{

  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);
  List<Person> get allUsersProfileList => usersProfileList.value;

  @override
  void onInit() {
  
    super.onInit();
    
    usersProfileList.bindStream(
      FirebaseFirestore.instance.collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot queryDataSnapshot){
          List<Person> profilesList = [];
          for(var eachProfile in queryDataSnapshot.docs){
              profilesList.add(Person.fromDataSnapshot(eachProfile));
          }
          return profilesList;
        })
    );
  } 



}