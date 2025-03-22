import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<String?> emailErrorText = Rx<String?>(null);
  Rx<String?> passwordErrorText = Rx<String?>(null);

  void validateEmail(String value) {
    emailErrorText.value = value.isEmpty
        ? 'Email cannot be empty'
        : !value.contains('@') || !value.contains('.')
            ? 'Invalid email'
            : null;
    update();
  }

  void validatePassword(String value) {
    passwordErrorText.value = value.isEmpty ? 'Password cannot be empty' : null;
    update();
  }

  void validateAll() {
    validateEmail(emailController.value.text);
    validatePassword(passwordController.value.text);
  }

  bool isValid() {
    return emailErrorText.value == null && passwordErrorText.value == null;
  }

  @override
  void onClose() {
    emailController.value.dispose();
    passwordController.value.dispose();
    super.onClose();
  }
}
