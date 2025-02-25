import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/Services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxString email = ''.obs;
  RxString password = ''.obs;
  RxBool isLoading = false.obs;

  void login() async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Oops!', 'Please fill in both fields!',
          backgroundColor: Colors.red.shade300);
      return;
    }
    isLoading.value = true;
    await _authService.login(email.value, password.value);
    isLoading.value = false;
  }

  void forgotPassword() async {
    if (email.isEmpty) {
      Get.snackbar('Oops!', 'Please enter your email!',
          backgroundColor: Colors.red.shade300);
      return;
    }
    isLoading.value = true;
    await _authService.forgotPassword(email.value);
    isLoading.value = false;
  }
}