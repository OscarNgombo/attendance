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

  String? get nameErrorText {
    final text = nameController.value.text;
    if (text.isEmpty) {
      return 'Please name can\'t be empty';
    }
    return null;
  }

  String? get emailErrorText {
    final text = emailController.value.text;
    if (text.isEmpty) {
      return null;
    }
    if (text.isEmail == false) {
      return 'Please enter correct email';
    }
    return null;
  }

  String? get phoneErrorText {
    final text = phoneController.value.text;
    if (text.isEmpty) {
      return null;
    }
    if (text.length < 10) {
      return 'Too shot for  a number';
    }
    if (text.length > 10) {
      return 'Too long for phone number';
    }
    return null;
  }

  String? get errorText {
    final text = passwordController.value.text;

    if (text.isEmpty) {
      return null;
    }
    if (text.length < 6) {
      return 'Too shot has to be 6 digits';
    }
    return null;
  }

  String? get errorMatchText {
    final text = passwordController.value.text;
    final text1 = password1Controller.value.text;
    if (text.isEmpty || text1.isEmpty) {
      return 'Password cannot be empty';
    }
    if (text != text1) {
      return 'Password does not match';
    }
    return null;
  }
}
