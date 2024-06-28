import 'dart:async';
import 'dart:developer';
import 'package:attendance/models/chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DbData extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userDatabaseReference =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _checkIn =
      FirebaseDatabase.instance.ref().child('checkIn');
  final DatabaseReference _checkOut =
      FirebaseDatabase.instance.ref().child('checkOut');
  // Get the logged-in user ID.
  final loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
  DateTime currentDateTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    syncUserInformation();
  }
// Method to sync user information with the database
  Future<void> syncUserInformation() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      // Check if the user already exists in the database before syncing
      DataSnapshot snapshot = (await _userDatabaseReference.orderByChild('userID').equalTo(userId).once()) as DataSnapshot;

      if (snapshot.value != null && (snapshot.value as Map).isNotEmpty) {
        log('User already exists in the database. No need to sync.');
        return; // Exit the function if the user already exists
      }

      // Get the user information
      String userEmail = currentUser.email ?? '';
      String userPhone = currentUser.phoneNumber ?? '';
      String userName = currentUser.displayName ?? '';
      String profileUrl = currentUser.photoURL ?? '';
      bool isAdmin = false;

      // Store the user information in the database
      await _userDatabaseReference.child(userId).set({
        'email': userEmail,
        'phone': userPhone,
        'name': userName,
        'profileURL': profileUrl,
        'isAdmin': isAdmin,
        // Other user-related information fields
      });
    }
  }

  Future<void> createCheckIn(
      {required String userId,
      required String location,
      required String deviceId}) async {
    String currentDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
    String currentTime = DateFormat('HH:mm:ss').format(currentDateTime);

     _checkIn.push().set({
      'userID': userId,
      'location': location,
      'deviceID': deviceId,
      'date': currentDate,
      'time': currentTime,
    });
  }
  Future<void> createCheckOut(
      {required String userId,
        required String location,
        required String deviceId}) {
    String currentDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
    String currentTime = DateFormat('HH:mm:ss').format(currentDateTime);

    return _checkOut.push().set({
      'userID': userId,
      'location': location,
      'deviceID': deviceId,
      'date': currentDate,
      'time': currentTime,
    });
  }

  Future<bool> checkOutStatus() async {
    // Get today's date.
    final todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Create a Completer to handle the asynchronous operation and return the boolean result.
    Completer<bool> completer = Completer<bool>();

    // Query the database based on the logged-in user ID and today's date.
    final query = FirebaseDatabase.instance
        .ref('checkOut')
        .orderByChild('userID')
        .equalTo(loggedInUserId);

    // Listen for a single value event.
    query.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        // Check if the user has a check-in for today.
        bool hasTodaysCheckIn = false;
        for (var childSnapshot in snapshot.children) {
          final date = childSnapshot.child("date").value.toString();
          if (date == todaysDate) {
            hasTodaysCheckIn = true;
            // log(childSnapshot.value.toString());
            break;
          }
        }
        completer.complete(hasTodaysCheckIn);
      } else {
        completer.complete(false); // User has no check-ins
      }
    });

    return completer.future;
  }

  Future<Map<String, dynamic>> readData() async {
    final snapshot = await _checkIn.get();
    if (snapshot.exists) {
      return snapshot.value as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  readDataBasedOnLoggedInUser() {
    // Query the database based on the logged-in user ID.
    final query = FirebaseDatabase.instance
        .ref('checkIn')
        .orderByChild('userID')
        .equalTo(loggedInUserId);
    // Listen for data changes.
    query.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        // Extract the data and print it to the console.
        for (var childSnapshot in snapshot.children) {
          // log(childSnapshot.value.toString());
        }
      }
    });
  }

  Future<bool> hasTodaysCheckIn() async {
    // Get today's date.
    final todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Create a Completer to handle the asynchronous operation and return the boolean result.
    Completer<bool> completer = Completer<bool>();

    // Query the database based on the logged-in user ID and today's date.
    final query = FirebaseDatabase.instance
        .ref('checkIn')
        .orderByChild('userID')
        .equalTo(loggedInUserId);

    // Listen for a single value event.
    query.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        // Check if the user has a check-in for today.
        bool hasTodaysCheckIn = false;
        for (var childSnapshot in snapshot.children) {
          final date = childSnapshot.child("date").value.toString();
          if (date == todaysDate) {
            hasTodaysCheckIn = true;
            // log(childSnapshot.value.toString());
            completer.complete(hasTodaysCheckIn);
            break;
          }
        }
        completer.complete(hasTodaysCheckIn);
      } else {
        completer.complete(false); // User has no check-ins
      }
    });
    return completer.future;
  }

  Future<bool> userRole() async {
    final snapshot = await _userDatabaseReference.child("$loggedInUserId/isAdmin").get();
    final isAdmin = snapshot.value as bool;
    // log("the admin status is $isAdmin");
     return isAdmin;
  }

  Future<Map<String, List<Map<String, dynamic>>>> readCheckInData() async {
    // Create a map to organize data by date and check-in time.
    Map<String, List<Map<String, dynamic>>> organizedData = {};

    final snapshot = await _checkIn.get();

    if (snapshot.exists) {
      // Extract the data and organize it by date and check-in time.
      for (var childSnapshot in snapshot.children) {
        final data = childSnapshot as Map<String, dynamic>;
        final date = data['date'] as String;
        final checkInTime = data['time'] as String;

        // Create a key based on date to group data by date.
        final key = '$date - $checkInTime';

        if (!organizedData.containsKey(key)) {
          organizedData[key] = [];
        }

        organizedData[key]!.add(data);
      }
    }

    return organizedData;
  }

}
