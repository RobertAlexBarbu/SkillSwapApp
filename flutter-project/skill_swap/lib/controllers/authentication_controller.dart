
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/authentication/login.dart';
import 'package:skill_swap/home_screen/home.dart';
import 'package:skill_swap/models/person.dart' as personModel;
//import 'package:image_picker/image_picker.dart';

class AuthenticationController  extends GetxController{

  static AuthenticationController authController = Get.find();

  late Rx<File?> pickedFile;
  late Rx<User?> firebaseCurrentUser;

  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  pickImageFileFromGalery() async{
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if(imageFile != null){
      Get.snackbar("Profile Image", "you have successfully picked your profile image.");
    }

    pickedFile =Rx<File?>(File(imageFile!.path));
  }

  captureImageFromPhoneCamera() async{
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    
    if(imageFile != null){
      Get.snackbar("Profile Image", "you have successfully taken your profile image.");
    }

    pickedFile =Rx<File?>(File(imageFile!.path));
  }

  Future<String> uploadImageToStorage(File imageFile) async{
      Reference referenceStorage = FirebaseStorage.instance.ref()
                                  .child("Profile Images")
                                  .child(FirebaseAuth.instance.currentUser!.uid); 
      UploadTask task = referenceStorage.putFile(imageFile);
      TaskSnapshot snapshot = await task;

      String downloadURLOfImage = await snapshot.ref.getDownloadURL();
      return downloadURLOfImage;
  }


  createNewUserAccount(File imageProfile, String name, String age, String phoneNo, 
                       String profileHeading, String skillList, String email, String password)
  async {
    try{
      // 1. authenticate user with email + password
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      //2. upload profile image to storage 
      String urlOfDownloadedImage = await uploadImageToStorage(imageProfile);

      //3. save user info to firestore db
      personModel.Person personInstance = personModel.Person(
          uid: FirebaseAuth.instance.currentUser!.uid,
          email: email,
          password: password,
          imageProfile: urlOfDownloadedImage,
          name: name,
          age: int.parse(age),
          phoneNo: phoneNo,
          profileHeading: profileHeading,
          skillList: skillList,
          publishedDateTime: DateTime.now().millisecondsSinceEpoch
      );

      await FirebaseFirestore.instance.collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid).set(personInstance.toJson());
            

      

      Get.snackbar("Account created", "Congratulation your skill swap account has been created!");
      Get.to(Home());

    }catch(errorMsg){
        Get.snackbar("Account creation unsuccessful", "Error ocurred: $errorMsg");
    }

    
  }

  loginUser(String email, String password) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, 
            password: password
      );

      Get.snackbar("Successfull login", "You logged in successfull");
      Get.to(Home());
          
    }
    catch(errorMsg){
      Get.snackbar("Login unsuccessful", "Error occurred: $errorMsg");
    }
  }


  checkIfUserIsLoggedIn(User? currentUser){
    if(currentUser == null){
      Get.to(Login());
    }
    else{
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