import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      body: FutureBuilder(
        future: locationService.fetchLocation(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasData) {
            int distance = locationService.calculateDistance(
                snapshot.data!.latitude, snapshot.data!.longitude);
            return Card(
              elevation: 4,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (distance <= 34)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                  'Hello ${authService.getCurrentUser()?.displayName ?? "User"}, Good to see you today please check in to work below!'),
                            ),
                          ),
                          // ListTile(
                          //   title: Text(
                          //       'Your current location:\n Latitude: ${snapshot.data!.latitude}, Longitude: ${snapshot.data!.longitude}'),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your onPressed functionality here
                                checkIn
                                    .createCheckIn(
                                        userId: userId,
                                        location:
                                            "${snapshot.data!.latitude}, ${snapshot.data!.longitude}",
                                        deviceId:
                                            locationService.deviceIdentifier)
                                    .then((_) async => Get.snackbar(
                                          "Check In",
                                          "You have successfully checked in to work!",
                                          duration: const Duration(seconds: 3),
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          colorText: Colors.white,
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                        ));
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).primaryColor),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Check In',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    if (distance >= 35)
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                'It is Best for you to get to work so as to check-in',
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  // Add any other relevant styles here
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                'Distance from work is: \n${locationService.calculateDistance(snapshot.data!.latitude, snapshot.data!.longitude)} meters',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  // Add any other relevant styles here
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    // ListTile(
                    //   title: Text('Your device ID is: \n ${locationService.deviceIdentifier}'),
                    // ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
