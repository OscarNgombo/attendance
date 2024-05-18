// Define a bindings class to handle dependency injection for the authentication service
import 'package:attendance/services/auth.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the authentication service for use in the specified route or page
    Get.put(AuthMethods());
  }
}
