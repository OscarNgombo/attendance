import 'package:attendance/bindings/auth.dart';
import 'package:attendance/bindings/home_screen.dart';
import 'package:attendance/ui/screens/login.dart';
import 'package:attendance/services/auth.dart';
import 'package:attendance/ui/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/screens/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authService = Get.put(AuthMethods());
  @override
  void initState() {
    super.initState();
    checkUserLoggedInAndRemove;
  }

  void checkUserLoggedInAndRemove() {
    if (authService.isUserLoggedIn()) {
      authService.signOut();
    }
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Home Page'),
      scrollBehavior: const MaterialScrollBehavior(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      initialRoute: authService.isUserLoggedIn() ? '/home' : '/login',
      getPages: [
        GetPage(
            name: '/login',
            page: () => const LoginWidget(),
            binding: AuthBinding()),
        GetPage(
            name: '/signup',
            page: () => const SignUpWidget(),
            binding: AuthBinding()),
        GetPage(
          name: '/home',
          page: () => const MyHomePage(
            title: 'Attendance',
          ),
          binding: LocationBinding(),
        ),
      ],
    );
  }
}
