import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  String? skillName;
  String? skillDescription;
  List<String> categories;
  int? publishedDateTime;

  Skill({
    this.skillName,
    this.skillDescription,
    required this.categories,
    this.publishedDateTime
  });

  static Skill fromDataSnapshot(DocumentSnapshot snapshot){
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Skill(
      skillName: dataSnapshot["skillName"],
      skillDescription: dataSnapshot["skillDescription"],
      categories: List<String>.from(dataSnapshot["categories"] ?? []), 
      publishedDateTime: dataSnapshot["publishedDateTime"]
    );
  }

  Map<String, dynamic> toJson() => {
    "skillName": skillName,
    "skillDescription": skillDescription,
    "categories": categories,
    "publishedDateTime": publishedDateTime
  };



}