import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';


class UserDetailsScreen extends StatefulWidget {

  String? userId;

  UserDetailsScreen({super.key, this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? uid='';
  String? email='';
  String? password='';
  String? name='';
  String? age='';
  String? phoneNo='';
  String? profileHeading='';
  String? skillList='';
  String? imageProfile='';
  String? publishedDateTime='';

  //slider img
  String urlImage1 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";
  String urlImage2 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";
  String urlImage3 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";
  String urlImage4 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";
  String urlImage5 = "https://firebasestorage.googleapis.com/v0/b/swappyskills.firebasestorage.app/o/Placeholder%2Fprofile_Default_image.jpg?alt=media&token=a3f4e00c-cd11-46bc-a7ff-bf9c745dff8d";



  retrieveUserInfo() async{
      FirebaseFirestore.instance.collection("users").doc(widget.userId).get().then((snapshot){
          if(snapshot.exists){
            if(snapshot.data()!["urlImage1"] != null){
              setState(() {
                urlImage1 = snapshot.data()!["urlImage1"];
                urlImage2 = snapshot.data()!["urlImage2"];
                urlImage3 = snapshot.data()!["urlImage3"];
                urlImage4 = snapshot.data()!["urlImage4"];
                urlImage5 = snapshot.data()!["urlImage5"];
              });
            }

            setState(() {
              name = snapshot.data()!["name"];
              age = snapshot.data()!["age"].toString();
              phoneNo = snapshot.data()!["phoneNo"];
              profileHeading = snapshot.data()!["profileHeading"];
              skillList = snapshot.data()!["skillList"];
          
            });
          }
      });
    }


@override
  void initState() {
    super.initState();
    retrieveUserInfo();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
             //img slider
             Align(
              alignment: Alignment.center,
              child:  SizedBox(
                height: MediaQuery.of(context).size.height *0.2,
                width: MediaQuery.of(context).size.width * 0.4,
               
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.3),
                    autoScrollDuration: const Duration(seconds: 2),
                    animationPageDuration: const Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: true,
                    autoScroll: true,
                    items: [
                      Image.network(urlImage1, fit: BoxFit.cover),
                      Image.network(urlImage2, fit: BoxFit.cover),
                      Image.network(urlImage3, fit: BoxFit.cover),
                      Image.network(urlImage4, fit: BoxFit.cover),
                      Image.network(urlImage5, fit: BoxFit.cover),
                    ]
                  ), 
                ),
              ),
             ),
              

              const SizedBox(height: 10,),

              const SizedBox(height: 30,),

              //personal info title
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Personal info",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(
                color: Colors.white,
                thickness: 2,
              ),

              Container(
                //color:  const Color.fromARGB(255, 228, 223, 174),
                padding: const EdgeInsets.all(20),
                child: Table(
                  children: [
                    //name
                    TableRow(
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          name!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]
                    ),
                    //extra tabel row
                    const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                    ),
                    //age
                    TableRow(
                      children: [
                        const Text(
                          "Age",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          age!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]
                    ),
                     //extra tabel row
                    const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                    ),
                    //phone no
                    TableRow(
                    children: [
                      const Text(
                        "Phone Nomber",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        phoneNo!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]
                  ),
                     //extra tabel row
                    const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                    ),
                    // profile heading
                    TableRow(
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        profileHeading!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]
                  ),
                   
                ],
              )
            ),
              
              //skill list title
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Skills information",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(
                color: Colors.white,
                thickness: 2,
              ),

              Container(
                padding:  const EdgeInsets.all(20),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        const Text(
                          "Skills",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          skillList!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]
                    ),
                  ],
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}