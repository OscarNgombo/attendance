import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/widgets/checkIn.dart';
import 'package:attendance/ui/widgets/checkOut.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocationService locationService = Get.find();
  final authService = Get.put(AuthMethods());
  final checkIn = Get.put(DbData());

  @override
  void initState() {
    locationService.getDeviceId();
    locationService.fetchLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userId = authService.getCurrentUser()!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(widget.title),
            TextButton(
              onPressed: () {
                authService.signOut();
                Get.offAndToNamed("/login");
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary),
              ),
              child: Row(
                children: [
                  const Text("Logout"),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.logout_outlined,
                    fill: 1.0,
                    color: Colors.blue[600],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder<bool>(
        future: checkIn.hasTodaysCheckIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the result.
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              // Handle any error that occurred during the future computation.
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data == true) {
                return CheckOutWidget(
                  locationService: locationService,
                  checkIn: checkIn,
                  authService: authService,
                  userId: userId,
                );
              } else {
                return CheckInWidget(
                  locationService: locationService,
                  authService: authService,
                  checkIn: checkIn,
                  userId: userId,
                );
              }
            }
          }
        },
      ),
    );
  }
}
