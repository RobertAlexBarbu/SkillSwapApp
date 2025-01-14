import 'package:skill_swap/models/person.dart';
import 'package:skill_swap/models/swap_request.dart';

class SkillSwapRequestMessage {
  int? id;
  String userId;
  Person user; // Assuming `Person` corresponds to the ASP.NET `User`
  int skillSwapRequestId;
  SwapRequest skillSwapRequest;
  int createdAt; // Timestamp in milliseconds
  String message;

  SkillSwapRequestMessage({
    this.id,
    required this.userId,
    required this.user,
    required this.skillSwapRequestId,
    required this.skillSwapRequest,
    required this.createdAt,
    required this.message,
  });

  factory SkillSwapRequestMessage.fromJson(Map<String, dynamic> json) {
    return SkillSwapRequestMessage(
      id: json['id'] as int?,
      userId: json['userId'] as String,
      user: Person.fromJson(json['user'] as Map<String, dynamic>),
      skillSwapRequestId: json['skillSwapRequestId'] as int,
      skillSwapRequest: SwapRequest.fromJson(
          json['skillSwapRequest'] as Map<String, dynamic>),
      createdAt: _convertToTimestamp(json['createdAt']),
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'skillSwapRequestId': skillSwapRequestId,
      'message': message,
    };
  }

  static int _convertToTimestamp(dynamic value) {
    if (value is String) {
      return DateTime.parse(value).millisecondsSinceEpoch;
    } else if (value is int) {
      return value;
    }
    throw Exception("Invalid date format");
  }
}
