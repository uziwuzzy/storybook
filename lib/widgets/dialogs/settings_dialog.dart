import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/config/app_colors.dart';
import 'package:storybook/controllers/home_controller.dart';
import 'package:storybook/utils/ui_utils.dart';
import 'package:storybook/widgets/settings/settings_option.dart';

class SettingsDialog {
  static void show(HomeController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            // Menu title
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Menu options
            SettingsOption(
              icon: Icons.person,
              label: 'My Profile',
              onTap: () {
                Get.back();
                UiUtils.showComingSoonMessage('Profile');
              },
            ),
            const Divider(height: 1),
            SettingsOption(
              icon: Icons.stars,
              label: 'Premium Subscription',
              onTap: () {
                Get.back();
                UiUtils.showComingSoonMessage('Premium subscription');
              },
            ),
            const Divider(height: 1),
            SettingsOption(
              icon: Icons.music_note,
              label: 'Sound Settings',
              onTap: () {
                Get.back();
                UiUtils.showComingSoonMessage('Sound settings');
              },
            ),
            const Divider(height: 1),
            SettingsOption(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
                Get.back();
                _showLogoutConfirmation(controller);
              },
              isDestructive: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static void _showLogoutConfirmation(HomeController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 16),
              const Text(
                'Leaving so soon?',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Stay',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}