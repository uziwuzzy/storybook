import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/routes/app_routes.dart';
import 'package:storybook/config/app_colors.dart';
import 'package:storybook/widgets/dialogs/voice_option_item.dart';

class ListenOptionsDialog extends StatelessWidget {
  const ListenOptionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Professional voice-over',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Professional voice options
            VoiceOptionItem(
              icon: Icons.child_care,
              name: 'Jasper',
              color: AppColors.success,
              onTap: () {
                Get.back();
                Get.offNamed(
                  AppRoutes.BOOK_READER,
                  arguments: {
                    'isListening': true,
                    'narratorName': 'Jasper',
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            VoiceOptionItem(
              icon: Icons.record_voice_over,
              name: 'Nick Zhurov',
              color: AppColors.success,
              onTap: () {
                Get.back();
                Get.offNamed(
                  AppRoutes.BOOK_READER,
                  arguments: {
                    'isListening': true,
                    'narratorName': 'Nick Zhurov',
                  },
                );
              },
            ),

            const Divider(height: 32),

            // My voice-overs section
            const Text(
              'My voice-overs',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 20,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Empty state for my voice-overs
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'You haven\'t voice-overed this story yet',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // Close button
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}