import 'dart:ui';

import 'package:attendance/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignupWidget extends StatefulWidget {

  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final AuthMethods authService = Get.find();
  @override
  void initState() {
    super.initState();
    authService.auth;
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
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  controller: authService.email,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: authService.password,
                  obscureText: true,
                    // Add password validation logic
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: authService.password1,
                  obscureText: true,

                  // Add password validation logic
                ),
                  // if(authService.isPasswordTouched)
                  // const Text("Password has to match",style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic),),
                Padding(
                  padding: const EdgeInsets.only(top:16.0),
                  child:  ElevatedButton(
                    onPressed: () {
                      // Handle signup process
                      if (authService.password.value == authService.password1.value) {
                        authService.onTextChanged();
                        authService.signUp(email: authService.email.value.text,password: authService.password.value.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: const Text('Sign Up',style: TextStyle(color: Colors.black),),

                  ),
                ),
                const SizedBox(height: 21),
                SignInButton(
                  text: "Sign Up with Google",
                  Buttons.google,
                  onPressed: () {
                    authService.signInWithGoogle();
                  },
                  shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
