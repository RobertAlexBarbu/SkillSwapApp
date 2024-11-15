import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/profile_controller.dart';

class SwippingScreen extends StatefulWidget {
  const SwippingScreen({super.key});

  @override
  State<SwippingScreen> createState() => _SwippingScreenState();
}

class _SwippingScreenState extends State<SwippingScreen> {

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        return PageView.builder(
        itemCount: profileController.allUsersProfileList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          final eachProfileInfo = profileController.allUsersProfileList[index];

          return DecoratedBox(
            //picture
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  eachProfileInfo.imageProfile.toString(),
                ), 
                fit: BoxFit.cover
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [


                  //filter list icon button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: IconButton(
                        onPressed: (){

                        },
                        icon: Icon(
                          Icons.filter_list,
                          size: 30,
                        )
                      ),
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: (){

                    },
                    child: Column(
                      children: [

                        //name
                        Text(
                          eachProfileInfo.name.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4
                          ),
                        ),

                        // age
                        Text(
                          eachProfileInfo.age.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontSize: 14,
                    
                          ),
                        ),


                      ],
                    ),

                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  //img -fav- chat -button -like
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //FAV button
                      GestureDetector(
                        onTap: (){

                        },
                        child: Image.asset(
                          "images/favourite.png",
                          width: 50,
                        ),
                      ),
                      //chat button
                      GestureDetector(
                        onTap: (){

                        },
                        child: Image.asset(
                          "images/chat.png",
                          width: 60,
                        ),
                      ),
                   
                       //heart button
                      GestureDetector(
                        onTap: (){

                        },
                        child: Image.asset(
                          "images/heart.webp",
                          width: 50,
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        },
      );
      })
    );
  }
}