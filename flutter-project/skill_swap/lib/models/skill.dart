import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  String? skillName;
  String? skillDescription;
  String? category;
  String? userId;
  int? id;
  int? publishedDateTime;

  Skill({
    this.skillName,
    this.skillDescription,
    this.category,
    this.userId,
    this.id,
    this.publishedDateTime,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      skillName: json['skillName'] as String?,
      skillDescription: json['skillDescription'] as String?,
      category: json['category'] as String?,
      userId: json['userId'] as String?,
      id: json['id'] as int?,
      publishedDateTime: json['publishedDateTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'skillDescription': skillDescription,
      'category': category,
      'userId': userId,
      'id': id,
      'publishedDateTime': publishedDateTime,
    };
  }
}