import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/tabScreens/favorites_sent_favorites_recieved_screen.dart';
import 'package:skill_swap/tabScreens/like_sent_like_received_screen.dart';
import 'package:skill_swap/tabScreens/swipping_screen.dart';
import 'package:skill_swap/tabScreens/user_details_screen.dart';
import 'package:skill_swap/tabScreens/view_send_view_received_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int screenIndex = 0;
  List tabScreensList = [
    SwippingScreen(),
    ViewSendViewReceivedScreen(),
    FavoritesSentFavoritesRecievedScreen(),
    LikeSentLikeReceivedScreen(),
    UserDetailsScreen(userId: FirebaseAuth.instance.currentUser!.uid),
  ];


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar( 
        onTap: (indexNumber){
            setState(() {
              screenIndex = indexNumber; 
            });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey ,
        selectedItemColor: const Color.fromARGB(255, 232, 220, 105),
        unselectedItemColor: Colors.white,
        currentIndex: screenIndex,
        items: const [

          //swapping screen
          BottomNavigationBarItem( 
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: ""
          ),

          // view screen button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye,
              size: 30,
            ), 
            label: ""
          ), 

          // favourite screen button
           BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              size: 30,
            ), 
            label: ""
          ),  

         // like sent like recieved screen button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 30,
            ), 
            label: ""
          ),  

        // user detail screen button
         BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
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