import 'package:attendance/controllers/auth/login_controller.dart';
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
  final LoginController loginController = Get.put(LoginController());
  bool hidden = true;

  @override
  void initState() {
    super.initState();
  }

  // Method to handle user login
  void _submit() {
    controller.validateAll();
    if (controller.isValid()) {
      authService.signIn(
        email: controller.signEmController.value.text,
        password: controller.signPasswordController.value.text,
      );
    }
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
      body: Obx(
        () => Container(
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
                              "Please get Authenticated below",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: controller.emailErrorText.value,
                          labelText: 'Email',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: loginController.emailController.value,
                        onChanged: loginController.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: loginController.validatePassword,
                        obscureText: hidden,
                        controller: loginController.passwordController.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          isDense: true,
                          hintStyle: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          hintText: '6 digits long password',
                          errorText: controller.emailErrorText.value,
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
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        onTap: () => Get.toNamed('/password/recovery'),
                      ),
                      TextButton(
                          onPressed: () => Get.toNamed("/signup"),
                          child: const Text(
                            "New create Account?",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
