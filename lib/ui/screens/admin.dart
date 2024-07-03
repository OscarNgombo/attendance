
import 'package:attendance/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/models/checkIn.dart';
import 'package:attendance/services/auth.dart';

class AdminView extends StatelessWidget {
  AdminView({super.key});
  final checkIn = Get.put(DbData());
  final authService = Get.put(AuthMethods());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkIn.getCheckInData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Data has error ${snapshot.error}'),
          );
        } else {
          List<CheckInData> checkIns = snapshot.data ?? [];
          checkIns.sort((a, b) =>
              b.date.compareTo(a.date)); // Sort by most recent date first
          String? mostRecentDate =
          checkIns.isNotEmpty ? checkIns[0].date : null;

          return ListView.builder(
            itemCount: checkIns.length,
            itemBuilder: (context, index) {
              CheckInData checkInData = checkIns[index];
              bool isActive =
                  mostRecentDate != null && checkInData.date == mostRecentDate;

              return FutureBuilder(
                future: authService.getUsers(checkInData.userID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100, // Placeholder height
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error occurred: ${snapshot.error}');
                  } else {
                    List<UserProfile> users = snapshot.data ?? [];
                    if (snapshot.data == null || users.isEmpty) {
                      return const Text('User not found');
                    }
                    UserProfile user = users.first;
                    String userName = user.displayName;

                    return FutureBuilder(
                      future: checkIn.getCheckOutData(),
                      builder: (context, dipSnapshot) {
                        if (dipSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (dipSnapshot.hasError) {
                          return Center(
                            child: Text('Data has error ${dipSnapshot.error}'),
                          );
                        } else {
                          List<CheckInData> checkOuts = dipSnapshot.data ?? [];
                          checkOuts.sort((a, b) => b.date.compareTo(a.date));
                          CheckInData? checkOutData =
                          checkOuts.isNotEmpty ? checkOuts.first : null;

                          bool isRecentCheckInDateInCheckOutData = false; // Initialize the variable

                          if (checkOutData != null) {
                            int currentIndex = index;
                            if (currentIndex >= 0 && currentIndex < checkOuts.length) {
                              isRecentCheckInDateInCheckOutData = checkOuts[currentIndex].date == mostRecentDate;
                            }
                          }
                          return Card(
                            color: colorsCard(
                                isActive, isRecentCheckInDateInCheckOutData),
                              child: ListTile(
                                title: Text('Name: $userName'),
                                subtitle: OutlinedButton(
                                  onPressed: ()=>defaultListDialog(user.displayName,user.phoneNumber,user.email),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text("Date: ${checkInData.date}"),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Check In time: ${checkInData.time}"),
                                          const SizedBox(width: 10,),
                                          ((checkInData.date ==
                                              checkOutData?.date) &&
                                              (checkInData.userID ==
                                                  checkOutData?.userID))
                                              ? Text(
                                              "Check Out time: ${checkOutData != null ? checkOutData.time : 'Not available'}")
                                              : const Text("Checkout Time:  ")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                          );
                        }
                      },
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  colorsCard(bool isActive, bool isRecentCheckInDateInCheckOutData) {
    if (!isActive) {
      return Colors.grey;
    }
    if (isActive && isRecentCheckInDateInCheckOutData) {
      return Colors.greenAccent;
    }
    return Colors.redAccent;

  }

  void defaultListDialog(String displayName,String phone,String email) {
    Future.delayed(const Duration(seconds: 1), () {
    });
    Get.defaultDialog(
        title: 'Attendance',
        middleText: displayName,
        content: Column(
          children: [
            Text(displayName),
            Text(phone),
            Text(email)
          ],
        ),
        confirmTextColor: Colors.amberAccent,
        barrierDismissible: false,
        textCancel: 'Cancel');
  }
}
