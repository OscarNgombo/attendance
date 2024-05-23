// Initialize Firebase Authentication and Realtime Database
import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class DbData extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userDatabaseReference = FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _checkIn = FirebaseDatabase.instance.ref().child('checkIn');
// Method to sync user information with the database
  Future<void> syncUserInformation() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Get the user information
      String userId = currentUser.uid;
      String userEmail = currentUser.email ?? '';
      String userPhone = currentUser.phoneNumber ?? '';
      String userName = currentUser.displayName ?? '';
      String profileUrl = currentUser.photoURL ?? '';

      // Store the user information in the database
      await _userDatabaseReference.child(userId).set({
        'email': userEmail,
        'phone':userPhone,
        'name':userName,
        'profileURL':profileUrl,
        // Other user-related information fields
      });
    }
  }
  DateTime currentDateTime = DateTime.now();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    syncUserInformation();
  }


  Future<void> createCheckIn(
      {required String userId, required String location, required String deviceId}) {
    String currentDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
    String currentTime = DateFormat('HH:mm:ss').format(currentDateTime);

    return _checkIn.child(userId).set({
      'location':location,
      'deviceID': deviceId,
      'date':currentDate,
      'time': currentTime,
    });

  }
  readData() {
      _checkIn.onValue.listen((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        Object? values = dataSnapshot.value;
        log(values.toString());
      });
    }
  }

