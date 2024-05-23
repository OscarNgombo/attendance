// Define a bindings class to handle dependency injection for the location service
import 'package:attendance/controllers/data/db_data.dart';
import 'package:attendance/controllers/geolocator/geolocator_controller.dart' show LocationService;
import 'package:get/get.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the location service for use in the specified route or page
    Get.put(LocationService());
    Get.put(DbData());
  }
}
