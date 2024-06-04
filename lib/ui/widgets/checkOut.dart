import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/widgets/animatedMessage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.locationService.fetchLocation(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) =>
          Column(
            children: [
              widget.checkIn.checkOutStatus() == false
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                      'Hello ${widget.authService.getCurrentUser()?.displayName ?? "User"}, We hope you had great day of work today Check out Below!'),
                ),
              )
                  :
              // ListTile(
              //   title: Text(
              //       'Your current location:\n Latitude: ${snapshot.data!.latitude}, Longitude: ${snapshot.data!.longitude}'),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 10),
                child: widget.checkIn.checkOutStatus() == false
                    ? ElevatedButton(
                  onPressed: () {
                    // Add your onPressed functionality here
                    widget.checkIn
                        .createCheckOut(
                        userId: widget.userId,
                        location:
                        "${snapshot.data!.latitude}, ${snapshot.data!.longitude}",
                        deviceId:
                        widget.locationService.deviceIdentifier)
                        .then((_) async => Get.snackbar(
                      "Check In",
                      "You have successfully checked out from work!",
                      duration:
                      const Duration(seconds: 3),
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
                    'Check Out',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
                    : const AnimatedThankYouMessage(),
              )
            ],
          ),
    );
  }
}