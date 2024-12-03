import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  String? skillName;
  String? skillDescription;
  String? category;
  int? publishedDateTime;

  Skill({
    this.skillName,
    this.skillDescription,
    this.category,
    this.publishedDateTime
  });

  static Skill fromDataSnapshot(DocumentSnapshot snapshot){
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Skill(
      skillName: dataSnapshot["skillName"],
      skillDescription: dataSnapshot["skillDescription"],
      category: dataSnapshot["category"],
      publishedDateTime: dataSnapshot["publishedDateTime"]
    );
  }

  Map<String, dynamic> toJson() => {
    "skillName": skillName,
    "skillDescription": skillDescription,
    "category": category,
    "publishedDateTime": publishedDateTime
  };



}