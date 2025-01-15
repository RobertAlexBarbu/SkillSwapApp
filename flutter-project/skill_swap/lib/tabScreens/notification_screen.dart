import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/swap_request_controller.dart';
import 'package:skill_swap/interceptors/jwt_interceptor.dart';
import 'package:skill_swap/models/Status.dart';
import 'package:skill_swap/models/person.dart';
import 'package:skill_swap/models/skill.dart';
import 'package:skill_swap/models/swap_request.dart';
import 'package:skill_swap/tabScreens/see_user_profile.dart';

class NotificationScreen extends StatefulWidget {
  final String userId; // Pass the logged-in user's ID
  const NotificationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> skillsList = [];
  SwapRequestController swapRequestController = Get.put(SwapRequestController());
  List<SwapRequest> _requestNotifications = [];
  final dio = createDio();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchSwapRequests();
    _startPolling();
  }

  // Method to start polling for new notifications every 5 seconds
  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchSwapRequests();
    });
  }

  // Fetch swap requests from the backend
  Future<void> _fetchSwapRequests() async {
    final url = 'https://skillswapp-api.azurewebsites.net/SkillSwapRequest/GetReceivedRequestsByUserId/${widget.userId}';
  
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        //print('Response data: ${response.data}');
        List<dynamic> data = response.data;
        setState(() {
          _requestNotifications = data
              .map((json) => SwapRequest.fromJson(json))
              .where((request) => request.status == Status.pending)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }
  
  // Method to handle the accept action
  Future<void> _acceptRequest(SwapRequest request) async {
   try{
      try {
        final response = await dio.post('https://skillswapp-api.azurewebsites.net/SkillSwapRequest/AcceptSkillSwapRequest/${request.id}');
        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Swap accepted successfully.');
          setState(() {
            _requestNotifications.remove(request);
          });
        } else {
          throw Exception('Failed to accept swap: ${response.statusCode}');
        }
      } catch (error) {
        print('Error accepting swap: $error');
        
      }
    } catch (e) {
        Get.snackbar(
        "Error Accepting Skill",
        "An error occurred while accepting the skill: $e",
      );
    }
  }
  
Future<List<Skill>?> retrieveSkills(String uid) async {
  try {
    final response = await dio.get('https://skillswapp-api.azurewebsites.net/api/Skill/GetAllByUserId/$uid');
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data);
      return data.map((skillJson) => Skill.fromJson(skillJson)).toList();
    } else {
      throw Exception('Failed to fetch skills: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching skills: $error');
    return null; // Return null in case of an error
  }
}


  // Method to handle the decline action
  Future<void> _declineRequest(SwapRequest request) async {
      request.status = Status.declined;
    try{
      try {
        final response = await dio.post('https://skillswapp-api.azurewebsites.net/SkillSwapRequest/RejectSkillSwapRequest/${request.id}');
        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Swap declined successfully.');
          setState(() {
            _requestNotifications.remove(request);
          });
        } else {
          throw Exception('Failed to decline swap: ${response.statusCode}');
        }
      } catch (error) {
        print('Error declining swap: $error');
        
      }
    } catch (e) {
        Get.snackbar(
        "Error Accepting Skill",
        "An error occurred while accepting the skill: $e",
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        title:
        Center(
        child:
        Text(
          "Notifications",
          style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
        ),
        )
      ),
      body: _requestNotifications.isEmpty
          ? const Center(child: Text('No pending notifications'))
          : ListView.builder(
              itemCount: _requestNotifications.length,
              itemBuilder: (context, index) {
                final request = _requestNotifications[index];
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
                      "${request.requester?.name} wants to exchange ${request.offeredSkill?.skillName} for ${request.requestedSkill?.skillName}",   // Notification body
                      style: TextStyle(
                      ),
                    ),
                    trailing: request.status == Status.pending
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  _acceptRequest(request);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  _declineRequest(request);
                                },
                              ),

                              TextButton(
                                onPressed: ()  async{
                                  request.requester.skills =  await retrieveSkills(request.requesterID);
                                  Get.to(SeeUserProfile(userProfile: request.requester));
                                },
                                child: const Text(
                                  'See profile',

                                ),
                              ),
                            ],
                          )
                        : null, // If the status is not pending, no buttons are shown
                  ),
                );
              },
            ),
    );
  }
}
