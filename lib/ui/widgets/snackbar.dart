import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar showSuccess(BuildContext context, String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      elevation: 12.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
    );
  }

  static SnackBar showError(BuildContext context, String message) {
    return SnackBar(
      content: Text(message,
          style: TextStyle(
            color: Colors.red,
          )),
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      elevation: 12.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
    );
  }
}
