import 'dart:developer';

import 'package:attendance/controllers/data/update_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final AuthMethods authService = Get.find();
  final UpdateController controller = Get.put(UpdateController());
  final String _text = '';
  bool _show = false;

  @override
  void initState() {
    super.initState();
  }

  showError(){
    // "${controller.errorText}".isEmpty || "${controller.emailErrorText}".isEmpty || "${controller.phoneErrorText}".isEmpty ||"${controller.nameErrorText}".isEmpty ?
    _show = !_show;
  }

  void _submit() {
    controller.errorText == null ?
      authService.signUp(
        email: controller.emailController.value.text,
        password: controller.passwordController.value.text,
        displayName: controller.nameController.value.text,
        phoneNumber: controller.phoneController.value.text,
      ) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8,bottom: 4.0,right: 10,left: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(fontSize: 24),
                  error: _show == true ? ErrorText.showError(
                      "${controller.nameErrorText}"):null
                ),
                keyboardType: TextInputType.name,
                controller: controller.nameController.value,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0,right: 10,left: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(fontSize: 18),
                    error: _show == true ? ErrorText.showError(
                        "${controller.phoneErrorText}"):null),
                keyboardType: TextInputType.phone,
                controller: controller.phoneController.value,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0,right: 10,left: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Email',labelStyle: const TextStyle(fontSize: 18),
                    error: _show == true ? ErrorText.showError(
                        "${controller.emailErrorText}"):null),
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController.value,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0,right: 10,left: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',labelStyle: const TextStyle(fontSize: 18),
                    error: _show == true ? ErrorText.showError(
                        "${controller.errorText}"):null),
                controller: controller.passwordController.value,
                obscureText: true,
                validator: (value) =>
                    value == null ? 'Please enter Password' : null,
                onChanged: (value) => _text,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0,right: 10,left: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 18),
                    error: _show == true ? ErrorText.showError(
                        "${controller.errorMatchText}"):null,
                    border: const OutlineInputBorder(),
                    labelText: 'Repeat Password'),
                controller: controller.password1Controller.value,
                obscureText: true,
                validator: (value) =>
                    value == null ? 'Please enter Password' : null,
                onChanged: (value) => _text,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: 20,
                child: ElevatedButton(
                  onPressed: () {
                   setState(() {
                     showError();
                     return _submit();
                   });

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SignInButton(
                text: "Sign Up with Google",
                Buttons.google,
                onPressed: () => authService.signInWithGoogle(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ],
        ),
      ),
    );
  }
}
