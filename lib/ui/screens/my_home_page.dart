import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/screens/admin.dart';
import 'package:attendance/ui/widgets/checkIn.dart';
import 'package:attendance/ui/widgets/checkOut.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
   const MyHomePage({super.key, required this.title});

   final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final locationService = Get.put(LocationService());
  final authService = Get.put(AuthMethods());
  final checkIn = Get.put(DbData());
  @override
  void initState() {
    super.initState();
    checkIn.hasTodaysCheckIn();
    locationService.getDeviceId();
    locationService.fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> isAdmin = checkIn.userRole();
    String userId = authService.getCurrentUser()!.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const SizedBox(width: 5),
                    Icon(
                      Icons.logout_outlined,
                      size: 24,
                      color: Colors.blue[600],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: FutureBuilder(
          future: isAdmin,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                  strokeCap: StrokeCap.butt,
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data == false) {
                return FutureBuilder<bool>(
                    future: checkIn.hasTodaysCheckIn(),
                    builder: (context, AsyncSnapshot<bool> innerSnapshot) {
                      if (innerSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (innerSnapshot.hasError) {
                        return Text('Error: ${innerSnapshot.error}');
                      } else {
                        final hasTodaysCheckIn = innerSnapshot.data!;
                        // Display appropriate widget based on check-in status
                        return hasTodaysCheckIn
                            ? CheckOutWidget(
                                locationService: locationService,
                                checkIn: checkIn,
                                authService: authService,
                                userId: userId,
                              )
                            : CheckInWidget(
                                locationService: locationService,
                                authService: authService,
                                checkIn: checkIn,
                                userId: userId,
                              );
                      }
                    });
              } else {
                return AdminView();
              }
            } else {
              return const Center(
                child: Text('There is an error loading data'),
              );
            }
          },
        ));
  }
}
