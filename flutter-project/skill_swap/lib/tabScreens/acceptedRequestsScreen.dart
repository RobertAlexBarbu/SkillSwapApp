import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../interceptors/jwt_interceptor.dart';
import '../models/swap_request.dart';

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
    final url = 'http://10.0.2.2:5165/SkillSwapRequest/GetAcceptedRequestsByUserId/${widget.userId}';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Accepted Requests",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: _acceptedRequests.isEmpty
          ? const Center(child: Text('No accepted requests yet'))
          : ListView.builder(
        itemCount: _acceptedRequests.length,
        itemBuilder: (context, index) {
          final request = _acceptedRequests[index];
          return Card(
            color: Color(0xFFFFEEB2),
            margin: const EdgeInsets.all(8),
            child: ListTile(

              title: Text(

                request.title,
                style: const TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: Text(
                "You have accepted ${request.requester?.name}'s request to exchange ${request.offeredSkill?.skillName} for ${request.requestedSkill?.skillName}.",
                  style: const TextStyle(
                  color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}