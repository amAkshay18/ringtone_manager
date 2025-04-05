import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';

void main() {
  // Ensure that plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ringtone Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // System default theme (supports dark mode)
      home: HomeView(),
    );
  }
}
