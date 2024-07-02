import 'dart:developer';

import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/widgets/animatedMessage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

class CheckOutWidget extends StatefulWidget {
  const CheckOutWidget({
    super.key,
    required this.locationService,
    required this.checkIn,
    required this.authService,
    required this.userId,
  });

  final LocationService locationService;
  final DbData checkIn;
  final AuthMethods authService;
  final String userId;

  @override
  State<CheckOutWidget> createState() => CheckOutWidgetState();
}

class CheckOutWidgetState extends State<CheckOutWidget> {
  Position? _currentPosition; // Declare a member variable

  @override
  void initState() {
    super.initState();
    widget.checkIn.checkOutStatus();
    widget.locationService.fetchLocation().then((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: widget.checkIn.checkOutStatus(),
        builder: (context,AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          else {
            return snapshot.data == false
                ? FutureBuilder(
                    future: widget.authService.getUsers(widget.userId),
                    builder: (context, innerSnapshot) {
                      if (innerSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else if (innerSnapshot.hasError) {
                        return Center(
                          child: Text("Error: ${innerSnapshot.error}"),
                        );
                      }
                      else {
                        List<UserProfile> users = innerSnapshot.data ?? [];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                    'Hello ${users[0].displayName}, We hope you had a great day at work today. Check out below!'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.checkIn
                                      .createCheckOut(
                                          userId: widget.userId,
                                          location:
                                              "${_currentPosition?.latitude}, ${_currentPosition?.longitude}",
                                          deviceId: widget
                                              .locationService.deviceIdentifier)
                                      .then((_) async {
                                    Get.snackbar(
                                      "Check Out",
                                      "You have successfully checked out from work!",
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
                                    );
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
                                  'Check Out',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    })
                : const Center(child: AnimatedThankYouMessage());
          }
        });
  }
}
