import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateController extends GetxController {
  Rx<TextEditingController> password1Controller = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> signEmController = TextEditingController().obs;
  Rx<TextEditingController> signPasswordController =
      TextEditingController().obs;
  Rx<String?> nameErrorText = Rx<String?>(null);
  Rx<String?> emailErrorText = Rx<String?>(null);
  Rx<String?> phoneErrorText = Rx<String?>(null);
  Rx<String?> errorText = Rx<String?>(null);
  Rx<String?> errorMatchText = Rx<String?>(null);

  void validateAll() {
    nameErrorText.value =
        nameController.value.text.isEmpty ? 'Name cannot be empty' : null;
    emailErrorText.value = emailController.value.text.isEmpty
        ? 'Email cannot be empty'
        : emailController.value.text.contains('@') &&
                emailController.value.text.contains('.')
            ? null
            : 'Invalid email';
    phoneErrorText.value = phoneController.value.text.isEmpty
        ? 'Phone number cannot be empty'
        : phoneController.value.text.length < 10
            ? 'Phone number must be at least 10 digits'
            : phoneController.value.text.length > 10
                ? 'Phone number must be at most 10 digits'
                : null;

    final password = passwordController.value.text;
    errorText.value =
        password.length < 6 ? 'Password must be at least 6 characters' : null;

    final passwordConfirm = password1Controller.value.text;
    errorMatchText.value =
        password != passwordConfirm ? 'Passwords do not match' : null;

    update(); // Notify listeners of changes
  }

  bool isValid() {
    return nameErrorText.value == null &&
        emailErrorText.value == null &&
        phoneErrorText.value == null &&
        errorText.value == null &&
        errorMatchText.value == null;
  }

  @override
  void onInit() {
    passwordController.value;
    nameController.value;
    password1Controller.value;
    phoneController.value;
    emailController.value;
    signPasswordController.value;
    signEmController.value;
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.value.dispose();
    nameController.value.dispose();
    password1Controller.value.dispose();
    phoneController.value.dispose();
    emailController.value.dispose();
    signPasswordController.value.dispose();
    signEmController.value.dispose();
    super.dispose();
  }
}
