import 'package:attendance/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/models/checkIn.dart';
import 'package:attendance/services/auth.dart';

class CheckInListScreen extends StatelessWidget {
  CheckInListScreen({super.key});
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
          checkIns.sort((a, b) => b.date.compareTo(a.date)); // Sort by most recent date first
          String? mostRecentDate = checkIns.isNotEmpty ? checkIns[0].date : null;

          return ListView.builder(
            itemCount: checkIns.length,
            itemBuilder: (context, index) {
              CheckInData checkInData = checkIns[index];
              bool isActive = mostRecentDate != null && checkInData.date == mostRecentDate;
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
                    if (users.isEmpty) {
                      return const Text('User not found');
                    }
                    String userName = users[0].displayName;

                    return Card(
                      color: isActive ? Colors.greenAccent : Colors.grey, // Set color based on active/inactive status
                      child: ListTile(
                        title: Text('Name: $userName'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${checkInData.date}'),
                            Text('Time: ${checkInData.time}'),
                          ],
                        ),
                      ),
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
}
