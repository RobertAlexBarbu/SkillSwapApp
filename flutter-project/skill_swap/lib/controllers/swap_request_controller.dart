import 'package:get/get.dart';
import 'package:skill_swap/interceptors/jwt_interceptor.dart';
import 'package:skill_swap/models/swap_request.dart';
import 'package:skill_swap/models/Status.dart';
import 'dart:async';

class SwapRequestController extends GetxController {
  var notifications = <SwapRequest>[].obs; // Reactive list of notifications
  final dio = createDio();
  // Timer for polling new notifications
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    // Start polling for new notifications
    _startPolling();
  }

  // Start polling every 5 seconds (adjust as necessary)
  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchNewNotifications();
    });
  }

  // Stop polling when the controller is disposed
  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  // Fetch new notifications from the backend
  Future<void> fetchNewNotifications() async {
    final url = 'http://10.0.2.2:5165/SkillSwapRequest/GetReceivedRequestsByUserId/USER_ID'; // Replace with actual userId
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        notifications.value = data
            .map((json) => SwapRequest.fromJson(json))
            .where((request) => request.status == Status.pending)
            .toList();
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }
}
