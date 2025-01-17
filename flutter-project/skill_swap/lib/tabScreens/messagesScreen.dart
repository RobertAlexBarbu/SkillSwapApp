
import 'package:flutter/material.dart';

import '../interceptors/jwt_interceptor.dart';
import '../models/swap_request.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'messagesScreen.dart';



import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MessagesScreen extends StatefulWidget {
  final String userId;
  final int? requestId;
  final String? skill1;
  final String? skill2;

  const MessagesScreen({
    Key? key,
    required this.userId,
    required this.requestId,
    required this.skill1,
    required this.skill2,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late Dio _dio;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: 'https://skillswapp-api.azurewebsites.net')); // Replace with your API base URL
    _fetchMessagesPeriodically();
  }

  void _fetchMessagesPeriodically() async {
    const duration = Duration(seconds: 1);
    while (mounted) {
      await _fetchMessages();
      await Future.delayed(duration);
    }
  }

  Future<void> _fetchMessages() async {
    if (widget.requestId == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await _dio.get('/SkillSwapRequest/GetMessagesBySwapRequestId/${widget.requestId}');
      final List<dynamic> data = response.data;
      setState(() {
        _messages = data.map((msg) => msg as Map<String, dynamic>).toList();
      });
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || widget.requestId == null) return;

    try {
      final payload = {
        'userId': widget.userId,
        'skillSwapRequestId': widget.requestId,
        'message': _messageController.text.trim(),
      };

      final response = await _dio.post('/SkillSwapRequest/CreateSkillSwapRequestMessage', data: payload);

      if (response.statusCode == 200) {
        _messageController.clear();
        await _fetchMessages(); // Refresh messages after sending
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // Skill Swap Card
          Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.skill1 ?? 'Skill 1',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.swap_horiz, size: 24, color: theme.primaryColor),
                  Text(
                    widget.skill2 ?? 'Skill 2',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Messages List
          Expanded(
            child: _isLoading && _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser = message['userId'] == widget.userId;

                return Align(
                  alignment:
                  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? theme.primaryColor.withOpacity(0.8)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                        bottomLeft: isCurrentUser
                            ? const Radius.circular(12.0)
                            : Radius.zero,
                        bottomRight: isCurrentUser
                            ? Radius.zero
                            : const Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['user']['name'] ?? 'Unknown User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          message['message'] ?? '',
                          style: TextStyle(
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Input and Send Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('Send'),
                  style: ElevatedButton.styleFrom(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
