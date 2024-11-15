import 'package:cloud_firestore/cloud_firestore.dart';

class Person{

  String? uid;
  String? email;
  String? password;
  String? name;
  int? age;
  String? phoneNo;
  String? profileHeading;
  String? skillList;
  String? imageProfile;
  int? publishedDateTime;

  Person({
    this.uid,
    this.email,
    this.password,
    this.imageProfile,
    this.name,
    this.age,
    this.phoneNo,
    this.profileHeading,
    this.skillList,
    this.publishedDateTime
  });


  static Person fromDataSnapshot(DocumentSnapshot snapshot)
  {
      var dataSnapshot = snapshot.data() as Map<String, dynamic>;

      return Person(
        uid: dataSnapshot["uid"],
        email: dataSnapshot["email"],
        password: dataSnapshot["password"],
        imageProfile: dataSnapshot["imageProfile"],
        name : dataSnapshot["name"],
        age: dataSnapshot["age"],
        phoneNo: dataSnapshot["phoneNo"],
        profileHeading: dataSnapshot["profileHeading"],
        skillList: dataSnapshot["skillList"],
        publishedDateTime: dataSnapshot["publishedDateTime"]
      );

  }

  Map<String, dynamic> toJson()=>{
    "uid": uid,
    "email": email,
    "password": password,
    "imageProfile": imageProfile,
    "name": name,
    "age": age,
    "phoneNo": phoneNo,
    "profileHeading": profileHeading,
    "skillList": skillList,
    "publishedDateTime": publishedDateTime
  };

}