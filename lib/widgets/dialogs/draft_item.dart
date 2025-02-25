import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/routes/app_routes.dart';
import 'package:storybook/config/app_colors.dart';

class DraftItem extends StatelessWidget {
  final String name;

  const DraftItem({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
        Get.offNamed(
          AppRoutes.BOOK_READER,
          arguments: {
            'isRecording': true,
            'narratorName': name,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.mic,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Play button
            IconButton(
              icon: const Icon(Icons.play_circle_outlined),
              color: AppColors.secondary,
              onPressed: () {
                // Play the recording (demo)
              },
            ),
          ],
        ),
      ),
    );
  }
}