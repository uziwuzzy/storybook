import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/routes/app_pages.dart';
import 'package:storybook/routes/app_routes.dart';
import 'package:storybook/services/auth_service.dart';
import 'package:storybook/config/app_theme.dart';

void main() {
  // Initialize services
  Get.put(AuthService());

  runApp(
    GetMaterialApp(
      title: "Children's Book App",
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.fade,
    ),
  );
}