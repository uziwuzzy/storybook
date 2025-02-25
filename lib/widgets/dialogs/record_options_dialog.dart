import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/routes/app_routes.dart';
import 'package:storybook/widgets/dialogs/draft_item.dart';
import 'package:storybook/config/app_colors.dart';

class RecordOptionsDialog extends StatelessWidget {
  const RecordOptionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

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
              'New recording',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                color: AppColors.recording,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Narrator name input
            const Text(
              'Narrator\'s name:',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter name here',
                hintStyle: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Start button
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Get.back();
                  Get.offNamed(
                    AppRoutes.BOOK_READER,
                    arguments: {
                      'isRecording': true,
                      'narratorName': nameController.text,
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.recording,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Start Recording',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Drafts section
            const Text(
              'Drafts',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 20,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Draft items list
            // We'll modify DraftItem in another file
            const DraftItem(name: 'cipet'),
            const SizedBox(height: 8),
            const DraftItem(name: 'bagong'),

            const SizedBox(height: 16),

            // Close button
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}