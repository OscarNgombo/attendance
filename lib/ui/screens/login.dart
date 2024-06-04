import 'dart:developer';

import 'package:attendance/controllers/data/update_controller.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final UpdateController controller = Get.put(UpdateController());
  final authService = Get.put(AuthMethods());
  final String _text = '';
  bool hidden = true;

  @override
  void initState() {
    super.initState();
  }

  void _submit() {
    authService
        .signIn(
            email: controller.signEmController.value.text,
            password: controller.signPasswordController.value.text)
        .then((onValue) async => Get.snackbar(
            "Login Successful", "You have successfully logged in",
            duration: const Duration(seconds: 3)));
 // User successfully authenticated, show success message and navigate to the home screen
    // Future.delayed(const Duration(
    //     seconds: 3)); // Adjust the duration to match the Snackbar's duration
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        color: Theme.of(context).colorScheme.onSecondary,
        child: Center(
          child: Card(
            color: Theme.of(context).colorScheme.onSecondary,
            elevation: 10,
            child: Form(
              child: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  children: <Widget>[
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const Text(
                            "Please enter your account here",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        error: controller.emailErrorText != null
                            ? ErrorText.showError(
                                "${controller.emailErrorText}")
                            : null,
                        labelText: 'Email',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.signEmController.value,
                      onChanged: (text) => setState(() => _text),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (text) => setState(() => _text),
                      obscureText: hidden,
                      controller: controller.signPasswordController.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        isDense: true,
                        hintStyle:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        hintText: '6 digits long password',
                        error: controller.errorText != null
                            ? ErrorText.showError("${controller.errorText}")
                            : null,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          child: Icon(Icons.password_sharp),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              hidden = !hidden;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Icon(hidden
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                         _submit();
                          // (controller.signEmController.value.isBlank == false &&
                          //     controller.signPasswordController.value.isBlank==false)
                          //     ? _submit
                          //     : null;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      child: SignInButton(
                        text: "Sign In with Google",
                        Buttons.google,
                        onPressed: () => authService.signInWithGoogle(),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    InkWell(
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      onTap: () => Get.toNamed('/password/recovery'),
                    ),
                    TextButton(
                        onPressed: () => Get.toNamed("/signup"),
                        child: const Text(
                          "New create Account?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
