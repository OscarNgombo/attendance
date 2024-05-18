import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxController {
  // Function to fetch the user's current location
  Future<Position> fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled return an error message
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, return the current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  calculateDistance(double currentLat, double currentLon) {
    double workLon = 36.8119648;
    double workLat = -1.2903635;

    double distanceInMeters =
        Geolocator.distanceBetween(workLat, workLon, currentLat, currentLon);
    return distanceInMeters.toInt().round();
  }
  String deviceIdentifier = '';
  Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    deviceIdentifier = webInfo.vendor! +
        webInfo.userAgent! +
        webInfo.hardwareConcurrency.toString();
  } else {
    switch (Platform.operatingSystem) {
      case 'android':
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceIdentifier = androidInfo.id;
        break;
      case 'ios':
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor!;
        break;
      case 'windows':
        final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        deviceIdentifier = windowsInfo.deviceId;
        break;
      default:
      // Handle other platforms here if needed
        break;
    }

  }
  return deviceIdentifier;
  }
}
