import 'dart:async';
import 'package:attendance/models/check_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;

class DbData extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userDatabaseReference =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _checkIn =
      FirebaseDatabase.instance.ref().child('checkIn');
  final DatabaseReference _checkOut =
      FirebaseDatabase.instance.ref().child('checkOut');

  final loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
  DateTime currentDateTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    syncUserInformation();
    getCheckInData();
  }

  Future<void> syncUserInformation() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      DataSnapshot snapshot = await _userDatabaseReference.child(userId).get();

      if (snapshot.exists) {
        return; // User entry already exists, no need to update
      }

      String userEmail = currentUser.email ?? '';
      String userPhone = currentUser.phoneNumber ?? '';
      String userName = currentUser.displayName ?? '';
      String profileUrl = currentUser.photoURL ?? '';
      bool isAdmin = false;

      await _userDatabaseReference.child(userId).set({
        'email': userEmail,
        'phone': userPhone,
        'name': userName,
        'profileURL': profileUrl,
        'isAdmin': isAdmin,
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

  Future<Map<String, dynamic>> readData() async {
    final snapshot = await _checkIn.get();
    return snapshot.exists ? snapshot.value as Map<String, dynamic> : {};
  }

  readDataBasedOnLoggedInUser() {
    final query = FirebaseDatabase.instance
        .ref('checkIn')
        .orderByChild('userID')
        .equalTo(loggedInUserId);

    query.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        for (var childSnapshot in snapshot.children) {
          // log(childSnapshot.value.toString());
        }
      }
    });
  }

  Future<bool> checkOutStatus() async {
    final todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Completer<bool> completer = Completer<bool>();

    final query = FirebaseDatabase.instance
        .ref('checkOut')
        .orderByChild('userID')
        .equalTo(loggedInUserId);

    query.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        bool hasTodaysCheckOut = false;
        for (var childSnapshot in snapshot.children) {
          final date = childSnapshot.child("date").value.toString();
          if (date == todaysDate) {
            hasTodaysCheckOut = true;
            break;
          }
        }
        completer.complete(hasTodaysCheckOut);
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  Future<bool> hasTodaysCheckIn() async {
    final todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Completer<bool> completer = Completer<bool>();
    final query = FirebaseDatabase.instance
        .ref('checkIn')
        .orderByChild('userID')
        .equalTo(loggedInUserId);

    query.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        bool hasTodaysCheckIn = false;
        for (var childSnapshot in snapshot.children) {
          final date = childSnapshot.child("date").value.toString();
          if (date == todaysDate) {
            hasTodaysCheckIn = true;
            break;
          }
        }
        completer.complete(hasTodaysCheckIn);
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  Future<bool> userRole() async {
    final snapshot =
        await _userDatabaseReference.child("$loggedInUserId/isAdmin").get();
    final isAdmin = snapshot.value as bool;
    return isAdmin;
  }

  Future<List<CheckInData>> getCheckInData() async {
    List<CheckInData> checkIns = [];
    final query =
        FirebaseDatabase.instance.ref('checkIn').orderByChild('userID');
    DataSnapshot snapshot = await query.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic>? checkInMap =
          snapshot.value as Map<dynamic, dynamic>;
      checkInMap.forEach((key, value) {
        CheckInData checkIn = CheckInData.fromJson(value);
        checkIns.add(checkIn);
      });
    }
    return checkIns;
  }

  Future<List<CheckInData>> getCheckOutData() async {
    List<CheckInData> checkOut = [];
    final query =
        FirebaseDatabase.instance.ref('checkOut').orderByChild('userID');
    DataSnapshot snapshot = await query.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic>? checkOutMap =
          snapshot.value as Map<dynamic, dynamic>;
      checkOutMap.forEach((key, value) {
        CheckInData check = CheckInData.fromJson(value);
        checkOut.add(check);
      });
    }
    return checkOut;
  }

  String? userData(String userId) {
    String? userName;
    User? currentUser = _auth.currentUser;

    if (loggedInUserId == userId) {
      userName = currentUser!.displayName;
    }

    return userName;
  }

  Stream<List<CheckInData>> mergeCollections() {
    return rx_dart.Rx.combineLatest2(
      Stream.fromFuture(getCheckInData()),
      Stream.fromFuture(getCheckOutData()),
      (List<CheckInData> checkIn, List<CheckInData> checkOut) {
        List<CheckInData> mergedData = [];
        mergedData.addAll(checkIn);
        mergedData.addAll(checkOut);
        return mergedData;
      },
    );
  }
}
