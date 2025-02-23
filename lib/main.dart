import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/Services/AuthService.dart';
import 'package:storybook/Views/HomeScreen.dart';
import 'package:storybook/Views/LoginScreen.dart'; // The SVG version
import 'package:storybook/Views/ForgotPasswordScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthService()); // Register AuthService globally
    return GetMaterialApp(
      title: 'Children’s Book App',
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()), // Uses Views/LoginScreen.dart
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(
            name: '/forgot-password', page: () => ForgotPasswordScreen()),
      ],
      theme: ThemeData(
        fontFamily: 'Baloo',
        primarySwatch: Colors.blue,
      ),
    );
  }
}