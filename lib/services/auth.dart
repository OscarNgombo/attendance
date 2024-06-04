import 'dart:developer';
import 'package:attendance/controllers/data/update_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

class AuthMethods extends GetxController {
  final auth = FirebaseAuth.instance;
  final control = Get.put(UpdateController());
  final DatabaseReference _userDatabaseReference =
      FirebaseDatabase.instance.ref().child('users');

// sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: control.emailController.value.text.trim(),
            password: control.passwordController.value.text.trim(),
          )
          .then((user) async => await Get.offAndToNamed("/home"));
      // Store additional user details in the Realtime Database
      await _userDatabaseReference.set({
        'phoneNo': control.phoneController.value.text.trim(),
        'email': control.emailController.value.text.trim(),
        'name': control.nameController.value.text.trim(),
        // Additional user details can be added here
      });
    } on FirebaseAuthException catch (e) {
      // TODO
    }
    return null;
  }

  //sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await auth
          .signInWithEmailAndPassword(
            email: control.signEmController.value.text.trim(),
            password: control.signPasswordController.value.text.trim(),
          )
          .then((user) async => await Get.offAndToNamed("/home"));
    } on FirebaseAuthException catch (e) {
      // TODO
      log(e.toString());
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      try {
        await auth
            .signInWithCredential(credential)
            .then((firebaseUser) async => await Get.offAndToNamed("/home"));
      } catch (e) {
        // log(e.toString());
      }
    }
    return null;
  }

  // Sign out method
  void signOut() {
    _deleteCacheDir();
    FirebaseAuth.instance.signOut();
    // Force reauthentication to update the user's status
    // FirebaseAuth.instance
    //     .authStateChanges()
    //     .listen((User? user) {
    //   log("User after sign-out: $user");
    // });
  }

  User? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  bool isUserLoggedIn() {
    // log(getCurrentUser().toString());
    return getCurrentUser() != null;
  }

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
