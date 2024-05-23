import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar showSuccess(BuildContext context, String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      elevation: 12.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
    );
  }
}

class ErrorText {
  static Text showError(String message) {
    return Text(
      message,
      style: const TextStyle(
        color: Colors.red,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
