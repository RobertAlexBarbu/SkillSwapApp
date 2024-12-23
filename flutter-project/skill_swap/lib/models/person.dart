import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/models/skill.dart';

class Person {
  String? uid;
  String? email;
  String? password;
  String? name;
  int? age;
  String? phoneNo;
  String? profileHeading;
  String? imageProfile;
  int? publishedDateTime;
  String? fcmToken;
  List<Skill>? skills; // List to hold skills
  
  Person({
    this.uid,
    this.email,
    this.password,
    this.imageProfile,
    this.name,
    this.age,
    this.phoneNo,
    this.profileHeading,
    this.skills,
    this.publishedDateTime,
    this.fcmToken
  });

  // static Person fromDataSnapshot(DocumentSnapshot snapshot) {
  //   var dataSnapshot = snapshot.data() as Map<String, dynamic>;
  //
  //   var person = Person(
  //     uid: dataSnapshot["uid"],
  //     email: dataSnapshot["email"],
  //     password: dataSnapshot["password"],
  //     imageProfile: dataSnapshot["imageProfile"],
  //     name: dataSnapshot["name"],
  //     age: dataSnapshot["age"],
  //     phoneNo: dataSnapshot["phoneNo"],
  //     profileHeading: dataSnapshot["profileHeading"],
  //     publishedDateTime: dataSnapshot["publishedDateTime"],
  //   );
  //
  //   // Load skills from Firestore
  //   person.skills = [];
  //   person.getSkills().then((skills) {
  //     person.skills = skills;
  //   });
  //
  //   return person;
  // }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "name": name,
    "age": age,
    "phoneNo": phoneNo,
    "profileHeading": profileHeading,
    "imageProfile": imageProfile,
    "publishedDateTime": publishedDateTime,
    'skills': skills?.map((skill) => skill.toJson()).toList(),
    "fcmToken": fcmToken
  };

  // Future<List<Skill>> getSkills() async {
  //   final skillCollection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('skills');
  //   final snapshot = await skillCollection.get();
  //   return snapshot.docs.map((doc) => Skill.fromDataSnapshot(doc)).toList();
  // }

  // Convert JSON to Person object
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      uid: json["uid"] ?? "",
      email: json["email"] ?? "",
      imageProfile: json["imageProfile"] ?? "",
      name: json["name"] ?? "",
      age: json["age"] ?? 0,
      phoneNo: json["phoneNo"] ?? "",
      profileHeading: json["profileHeading"] ?? "",
      publishedDateTime: json["publishedDateTime"] ?? "",
      skills: (json['skills'] as List<dynamic>?)
          ?.map((skillJson) => Skill.fromJson(skillJson as Map<String, dynamic>))
          .toList(),
    );
  }

}
