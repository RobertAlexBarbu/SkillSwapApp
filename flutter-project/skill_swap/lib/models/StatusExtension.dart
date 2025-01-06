import 'package:skill_swap/models/Status.dart';

extension StatusExtension on Status {
  static Status fromString(String status) {
    return Status.values.firstWhere((e) => e.toString().split('.').last == status);
  }
}
