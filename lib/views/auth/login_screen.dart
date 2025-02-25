import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storybook/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Ensure no white background
      body: Stack(
        children: [
          // SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/login_background.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay (optional, low opacity)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade200.withOpacity(0.3),
                  Colors.purple.shade300.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Storytime Adventure!',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(3, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => _controller.email.value = value,
                        decoration: InputDecoration(
                          hintText: 'Your Magic Email',
                          hintStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.grey,
                          ),
                          prefixIcon:
                          const Icon(Icons.email, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) =>
                        _controller.password.value = value,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Your Secret Key',
                          hintStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.grey,
                          ),
                          prefixIcon:
                          const Icon(Icons.lock, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(
                          () => _controller.isLoading.value
                          ? const CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation(Colors.yellowAccent),
                      )
                          : GestureDetector(
                        onTap: _controller.login,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 50,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade300,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.yellow.shade600,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Let’s Dive In!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Get.toNamed('/forgot-password'),
                      child: const Text(
                        'Lost Your Key?',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}