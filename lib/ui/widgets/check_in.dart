import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CheckInWidget extends StatefulWidget {
  const CheckInWidget({
    super.key,
    required this.locationService,
    required this.authService,
    required this.checkIn,
    required this.userId,
    required this.reloadState, // Added callback for reloading state
  });

  final LocationService locationService;
  final AuthMethods authService;
  final DbData checkIn;
  final String userId;
  final VoidCallback reloadState; // Added callback for reloading state

  @override
  State<CheckInWidget> createState() => _CheckInWidgetState();
}

class _CheckInWidgetState extends State<CheckInWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: widget.locationService.fetchLocation(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          int distance = widget.locationService.calculateDistance(
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
                  if (distance >=
                      34) //needs to be changed currently to support testing
                    Column(
                      children: [
                        FutureBuilder<List<UserProfile>>(
                          future: widget.authService.getUsers(widget.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<UserProfile> users = snapshot.data ?? [];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                      'Hello ${users[0].displayName}, Good to see you today please check in to work below!'),
                                ),
                              );
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              final theme = Theme.of(context);
                              widget.checkIn
                                  .createCheckIn(
                                      userId: widget.userId,
                                      location:
                                          "${snapshot.data!.latitude}, ${snapshot.data!.longitude}",
                                      deviceId: widget
                                          .locationService.deviceIdentifier)
                                  .then((_) async {
                                if (mounted) {
                                  Get.snackbar(
                                    "Check In",
                                    "You have successfully checked in to work!",
                                    duration: const Duration(seconds: 3),
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor:
                                        theme.colorScheme.inversePrimary,
                                    colorText: Colors.white,
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                  );
                                  widget
                                      .reloadState(); // Call the callback to reload state
                                }
                              });
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
                        ),
                      ],
                    ),
                  if (distance <=
                      35) //needs to be changed currently to support testing
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
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Distance from work is: \n${widget.locationService.calculateDistance(snapshot.data!.latitude, snapshot.data!.longitude)} meters',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
