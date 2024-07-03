import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListItemView {
  ListItemView(Function() defaultListDialog);
  void defaultListDialog(String displayName,String phone,String email) {
    Future.delayed(const Duration(seconds: 1), () {
      print(Get.isDialogOpen);
    });
    Get.defaultDialog(
        title: 'Attendance',
        middleText: displayName,
        content: Column(
          children: [
            Text(phone),
            Text(email)
          ],
        ),
        textConfirm: "OK",
        confirmTextColor: Colors.amberAccent,
        barrierDismissible: false,
        textCancel: 'Cancel');
  }
}