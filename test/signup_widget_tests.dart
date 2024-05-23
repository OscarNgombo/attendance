import 'package:attendance/ui/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

void main() {
  testWidgets('SignupWidget has a title and form', (tester) async {
    // Build the SignupWidget
    await tester.pumpWidget(const SignUpWidget());

    // Find the title
    expect(find.text('User Signup'), findsOneWidget);

    // Find the form
    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('SignupWidget has email and password fields', (tester) async {
    // Build the SignupWidget
    await tester.pumpWidget(const SignUpWidget());

    // Find the email field
    expect(find.byKey(const Key('email_field')), findsOneWidget);

    // Find the password field
    expect(find.byKey(const Key('password_field')), findsOneWidget);
  });

  testWidgets('SignupWidget has a sign up button', (tester) async {
    // Build the SignupWidget
    await tester.pumpWidget(const GetMaterialApp(home: SignUpWidget()));

    // Find the sign up button
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('SignupWidget has a Google sign in button', (tester) async {
    // Build the SignupWidget
    await tester.pumpWidget(const GetMaterialApp(home: SignUpWidget()));

    // Find the Google sign in button
    expect(find.byType(SignInButton), findsOneWidget);
  });
}
