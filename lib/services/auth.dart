
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';


class AuthMethods extends GetxController{
  final auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  bool isPasswordTouched = false;
  bool emailError= false;

onTextChanged() {
  // Set the flag to true since the password field has been touched
  isPasswordTouched = true;
  }
  //sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
  if(validateEmail(email)) {
    UserCredential user =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return user;
  }
  return null;

  }

// sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
      UserCredential user =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return user;
  }

  Future<UserCredential?> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      try {
        UserCredential firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);


        return firebaseUser;
      } catch (e) {
        print(e);
      }
    }
    return null;
    }
  // Sign out method
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;

    } catch (e) {
      // print(e.toString());
      return false;
    }
  }
  bool validateEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }
  bool validatePassword(String password) {
    int lon = 6;
    int passwordLen = password.length;
    return passwordLen.isEqual(lon);
  }
  User? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  bool isUserLoggedIn() {
    return getCurrentUser() != null;
  }
  }

