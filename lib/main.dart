import 'package:attendance/bindings/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  runApp(const MyApp(),);
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: '/home',
      getPages: [
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
