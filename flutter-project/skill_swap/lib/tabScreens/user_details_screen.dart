import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/tabScreens/favorites_sent_favorites_recieved_screen.dart';
import 'package:skill_swap/tabScreens/like_sent_like_received_screen.dart';
import 'package:skill_swap/tabScreens/swipping_screen.dart';
import 'package:skill_swap/tabScreens/view_send_view_received_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  int screenIndex = 0;
  List tabScreensList = [
    SwippingScreen(),
    ViewSendViewReceivedScreen(),
    FavoritesSentFavoritesRecievedScreen(),
    LikeSentLikeReceivedScreen(),
    UserDetailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          )
        ],
      ),
      body: Center(
        child: Text(
          "User screen",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}