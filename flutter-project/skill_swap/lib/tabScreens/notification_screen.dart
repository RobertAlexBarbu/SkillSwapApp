import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/swap_request_controller.dart';
import 'package:skill_swap/interceptors/jwt_interceptor.dart';
import 'package:skill_swap/models/Status.dart';
import 'package:skill_swap/models/swap_request.dart';

class NotificationScreen extends StatefulWidget {
  final String userId; // Pass the logged-in user's ID
  const NotificationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  SwapRequestController swapRequestController = Get.put(SwapRequestController());
  List<SwapRequest> _notifications = [];
  final dio = createDio();
  late Timer _timer;
   
  @override
  void initState() {
    super.initState();
    _fetchInitialNotifications();
    _startPolling();
  }

   // Method to start polling for new notifications every 5 seconds
  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchInitialNotifications();
    });
  }

  Future<void> _fetchInitialNotifications() async {
  final url = 'http://10.0.2.2:5165/SkillSwapRequest/GetReceivedRequestsByUserId/${widget.userId}';
  
  try {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      print('Response data: ${response.data}');
      List<dynamic> data = response.data;
      setState(() {
        _notifications = data
            .map((json) => SwapRequest.fromJson(json))
            .where((request) => request.status == Status.pending)
            .toList()
            .cast<SwapRequest>();
      });
    }
  } catch (e) {
    print('Error fetching notifications: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No pending notifications'))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final request = _notifications[index];
                return Card(
                color: Colors.yellow.shade100,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    request.title,  // Hardcoded title
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  subtitle: Text(
                    "${request.requester?.name} wants to exchange ${request.offeredSkill?.skillName} for ${request.requestedSkill?.skillName}",   // Hardcoded body
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                ),
              );
        },
      ),
    );
  }
}
