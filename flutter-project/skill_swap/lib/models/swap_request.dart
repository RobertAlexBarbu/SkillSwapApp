import 'package:skill_swap/models/Status.dart';
import 'package:skill_swap/models/StatusExtension.dart';
import 'package:skill_swap/models/person.dart';
import 'package:skill_swap/models/skill.dart';

class SwapRequest {
  String? requesterID;
  String? receiverID;
  int? id;
  int? requestedSkillId;
  int? offeredSkillId;
  Status? status;
  int? createdAt;
  Person? requester; 
  Skill? requestedSkill;
  Skill? offeredSkill;

  // Hardcoded fields
  String title = "SkillSwap Request"; 

  SwapRequest({
    this.id,
    this.requesterID,
    this.receiverID,
    this.requestedSkillId,
    this.offeredSkillId,
    this.status,
    this.createdAt,
    this.requester,  
    this.offeredSkill,
    this.requestedSkill
  });

  factory SwapRequest.fromJson(Map<String, dynamic> json) {
    return SwapRequest(
      id: json['id'] as int?,
      requesterID: json['requesterId'] as String?,
      receiverID: json['receiverId'] as String?,
      requestedSkillId: json['requestedSkillId'] != null
          ? int.tryParse(json['requestedSkillId'].toString())
          : null,
      offeredSkillId: json['offeredSkillId'] != null
          ? int.tryParse(json['offeredSkillId'].toString())
          : null,
      status: json['status'] != null
          ? StatusExtension.fromString(json['status'] as String)
          : Status.pending,
      createdAt: _convertToTimestamp(json['createdAt']),
      requester: json['requester'] != null
          ? Person.fromJson(json['requester'])  // Deserialize requester into a Person object
          : null,
      offeredSkill: json['offeredSkill'] != null
          ? Skill.fromJson(json['offeredSkill'])  // Deserialize requester into a Person object
          : null,
      requestedSkill: json['requestedSkill'] != null
          ? Skill.fromJson(json['requestedSkill'])  // Deserialize requester into a Person object
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterID,
      'receiverId': receiverID,
      'requestedSkillId': requestedSkillId,
      'offeredSkillId': offeredSkillId,
      'status': status?.name,
      'createdAt': createdAt,
      'requester': requester?.toJson(),  // Convert requester back to JSON if needed
    };
  }

  static int? _convertToTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        DateTime dateTime = DateTime.parse(value);
        return dateTime.millisecondsSinceEpoch;
      } catch (e) {
        return null;
      }
    } else if (value is int) {
      return value;
    } else {
      return null;
    }
  }
}
