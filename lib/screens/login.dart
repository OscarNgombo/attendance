import 'dart:ui';
import 'package:attendance/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final AuthMethods authService = Get.find();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
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
                    // const Text("Invalid Email",style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic),),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    controller: authService.password,
                    onTap: authService.onTextChanged,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // if(authService.password.value.text.length)
                  //   const Text("Password is short cannot be empty and has to be 6 digits long",style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic),),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                    child:  ElevatedButton(
                      onPressed: () {
                        // Handle signup process
                        authService.signIn(email: authService.email.value.text,password: authService.password.value.text);
                                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      child: const Text('Sign In',style: TextStyle(color: Colors.black),),
          
                    ),
                  ),
                  const SizedBox(height: 10),
                  SignInButton(
                      text: "Sign In with Google",
                      Buttons.google,
                      onPressed: () {
                        authService.signInWithGoogle();
                      },
                      shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),)
                  ),
                  TextButton(onPressed: ()=>Get.toNamed("signup"), child: const Text("Create Account",style: TextStyle(color: Colors.black,fontSize: 14),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
