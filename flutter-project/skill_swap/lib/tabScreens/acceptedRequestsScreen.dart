import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../interceptors/jwt_interceptor.dart';
import '../models/swap_request.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'messagesScreen.dart';

class AcceptedRequestsScreen extends StatefulWidget {
  final String userId; // Pass the logged-in user's ID
  const AcceptedRequestsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AcceptedRequestsScreen> createState() => _AcceptedRequestsScreenState();
}

class _AcceptedRequestsScreenState extends State<AcceptedRequestsScreen> {
  List<SwapRequest> _acceptedRequests = [];
  final dio = createDio();

  @override
  void initState() {
    super.initState();
    _fetchAcceptedRequests();
  }

  // Fetch accepted swap requests from the backend
  Future<void> _fetchAcceptedRequests() async {
    final url =
        'https://skillswapp-api.azurewebsites.net/SkillSwapRequest/GetAcceptedRequestsByUserId/${widget.userId}';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        setState(() {
          _acceptedRequests = data.map((json) => SwapRequest.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error fetching accepted requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title:  Center(
          child: Text(
            "Swap Chats",
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Adds 20px padding to all sides
        child: _acceptedRequests.isEmpty
            ? const Center(child: Text('No accepted requests yet'))
            : ListView.builder(
          itemCount: _acceptedRequests.length,
          itemBuilder: (context, index) {
            final request = _acceptedRequests[index];

            // Check if the logged-in user is the receiver or the sender
            final isUserReceiver = request.receiver?.uid == widget.userId;
            final message = isUserReceiver
                ? "You accepted ${request.requester?.name}'s request to exchange ${request.offeredSkill?.skillName} for ${request.requestedSkill?.skillName}."
                : "${request.receiver?.name} accepted your request to exchange ${request.offeredSkill?.skillName} for ${request.requestedSkill?.skillName}.";

            return Card(
              elevation: 4,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  request.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),
                ),
                subtitle: Text(
                  message,
                  style: TextStyle(

                  ),
                ),
                onTap: () {
                  // Navigate to MessagesScreen using Get.to()
                  Get.to(MessagesScreen(
                    userId: widget.userId,
                    requestId: request.id,
                    skill1: request.requestedSkill?.skillName,
                    skill2: request.offeredSkill?.skillName,
                  ));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}