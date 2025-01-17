import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/tabScreens/acceptedRequestsScreen.dart';
import 'package:skill_swap/tabScreens/notification_screen.dart';
import 'package:skill_swap/tabScreens/search_skills.dart';
import 'package:skill_swap/tabScreens/swipping_screen.dart';
import 'package:skill_swap/tabScreens/user_details_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int screenIndex = 0;
  List tabScreensList = [
    SwippingScreen(),
    SearchSkills(),
    UserDetailsScreen(userId: FirebaseAuth.instance.currentUser!.uid),
    NotificationScreen(userId: FirebaseAuth.instance.currentUser!.uid,),
    AcceptedRequestsScreen(userId: FirebaseAuth.instance.currentUser!.uid,)
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar( 
        onTap: (indexNumber){
            setState(() {
              screenIndex = indexNumber; 
            });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor:   theme.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: screenIndex,
        items: const [

          //swapping screen
          BottomNavigationBarItem( 
            icon: Icon(
              Icons.home_rounded,
              size: 30,
            ),
            label: ""
          ),
          // search  button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              size: 30,
              
            ), 
            label: ""
          ),  
        // user detail screen button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
              size: 30,
            ), 
            label: ""
          ), 
        // user detail screen button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_rounded,
              size: 30,
            ),
            label: ""
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
                size: 30,
              ),
              label: ""
          ),


        ],
      ),
      body: tabScreensList[screenIndex],
    );
  }
}