import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/authentication/login.dart';
import 'package:skill_swap/home_screen/home.dart';
import 'package:skill_swap/models/person.dart' as personModel;

import '../interceptors/jwt_interceptor.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController authController = Get.find();
  final dio = createDio();
  late Rx<File?> pickedFile;
  late Rx<User?> firebaseCurrentUser;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  pickImageFileFromGalery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      Get.snackbar(
          "Profile Image", "you have successfully picked your profile image.");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  captureImageFromPhoneCamera() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      Get.snackbar(
          "Profile Image", "you have successfully taken your profile image.");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

updateImageFromPhoneCamera(BuildContext context) async {
  imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
  updateImage(context);
}

updateImageFromGalery(BuildContext context) async {
  imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  updateImage(context);
}

updateImage(BuildContext context) async {
  if (imageFile != null) {
    final confirm = await showDialog<bool>(
      context: context, // Pass the context explicitly
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade200, // Set a background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Add rounded corners
        ),
        title: Text(
          "Confirm Profile Picture Change",
          style: TextStyle(
            color: Colors.grey.shade600, // Title text color
            fontWeight: FontWeight.bold, // Make the title bold
            fontSize: 20, // Increase font size
          ),
        ),
        content: Text(
          "Are you sure you want to change the profile picture?",
          style: TextStyle(
            color: Colors.grey.shade600, // Content text color
            fontSize: 16, // Content font size
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade300, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded button corners
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey.shade600, // Button text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.shade200, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded button corners
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Yes",
              style: TextStyle(
                color: Colors.grey.shade600, // Button text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Convert image to File
        pickedFile = Rx<File?>(File(imageFile!.path));
        // Upload to Firebase Storage
        String downloadURL = await uploadImageToStorage(pickedFile.value!);
        // Prepare data for backend
        final String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          final response = await dio.put(
            "http://10.0.2.2:5165/api/User/EditProfileImage/$userId",
            data: {
              "newProfileImageUrl": downloadURL, // Pass the URL to the backend
            },
            options: Options(
              headers: {
                'Content-Type': 'application/json',
              },
        ),
          );

          if (response.statusCode == 200) {
            Get.snackbar(
              "Success",
              "Profile picture updated successfully!",
            );
          } else {
            throw Exception("Failed to update the profile picture on backend.");
          }
        } else {
          throw Exception("User is not authenticated.");
        }
      } catch (e) {
        print("Error: $e");
        Get.snackbar(
          "Error",
          "Failed to update profile picture: $e",
        );
      }
    } else {
      Get.snackbar(
        "Cancelled",
        "Profile picture update cancelled.",
      );
    }
  } else {
    Get.snackbar(
      "No Image Selected",
      "Please select a valid image to proceed.",
    );
  }
}

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child("Profile Images")
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask task = referenceStorage.putFile(imageFile);
    TaskSnapshot snapshot = await task;

    String downloadURLOfImage = await snapshot.ref.getDownloadURL();
    return downloadURLOfImage;
  }

  createNewUserAccount(
      File imageProfile,
      String name,
      String age,
      String phoneNo,
      String profileHeading,
      String email,
      String password)
  async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      print(idToken);

      String urlOfDownloadedImage = await uploadImageToStorage(imageProfile);
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Get the device's FCM token
      String? token = await messaging.getToken();

      personModel.Person personInstance = personModel.Person(
          uid: FirebaseAuth.instance.currentUser!.uid,
          email: email,
          imageProfile: urlOfDownloadedImage,
          name: name,
          age: int.parse(age),
          phoneNo: phoneNo,
          profileHeading: profileHeading,
          publishedDateTime: DateTime.now().millisecondsSinceEpoch,
          fcmToken: token
      );




      final response = await dio.post("https://skillswapp-api.azurewebsites.net/api/User/Create",
          data: personInstance.toJson());

      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .collection('skills')
      //     .doc()
      //     .set({
      //   'skillName': '',
      //   'skillDescription': '',
      //   "category": '',
      //   'createdAt': FieldValue.serverTimestamp(),
      // });
      // await FirebaseFirestore.instance.collection("users")
      //       .doc(FirebaseAuth.instance.currentUser!.uid).set(personInstance.toJson());

      Get.snackbar("Account created",
          "Congratulation your skill swap account has been created!");
      Get.to(Home());
    } catch (errorMsg) {
      print(errorMsg);
      Get.snackbar("Account creation unsuccessful", "Error ocurred: $errorMsg");
    }
  }

  loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Successful login", "You logged in successfully");
      Get.to(Home());
    } catch (errorMsg) {
      Get.snackbar("Login unsuccessful", "Error occurred: $errorMsg");
    }
  }

  checkIfUserIsLoggedIn(User? currentUser) {
    if (currentUser == null) {
      Get.to(Login());
    } else {
      Get.to(Home());
    }
  }

  @override
  void onReady() {
    super.onReady();

    firebaseCurrentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(firebaseCurrentUser, checkIfUserIsLoggedIn);
  }
}
