import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  RxBool isLoggedIn = false.obs;
  static const String _tokenKey = 'auth_token';

  Future<void> login(String email, String password) async {
    // Simulate login without API
    await Future.delayed(const Duration(seconds: 1)); // Fake delay
    isLoggedIn.value = true;
    await _storage.write(key: _tokenKey, value: 'mock_token');
    Get.snackbar('Welcome!', 'You’re in—let’s read some stories!',
        backgroundColor: Colors.green.shade300,
        snackPosition: SnackPosition.BOTTOM);
    Get.offNamed('/home');
  }

  Future<void> forgotPassword(String email) async {
    // Simulate sending reset link
    await Future.delayed(const Duration(seconds: 1)); // Fake delay
    Get.snackbar(
      'Check Your Email!',
      'A magic reset link is on its way! (Pretend for now!)',
      backgroundColor: Colors.yellow.shade300,
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.back();
  }

  Future<String?> getToken() async => await _storage.read(key: _tokenKey);

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  Future<void> checkAuthStatus() async {
    final token = await getToken();
    if (token != null) {
      isLoggedIn.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }
}