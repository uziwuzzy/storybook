import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/config/app_colors.dart';

class RecordingOverlay extends StatelessWidget {
  const RecordingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookReaderController controller = Get.find<BookReaderController>();

    return Positioned(
      top: 70,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.recording,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Recording indicator with pulsing animation
            _buildPulsingRecordingIndicator(),
            const SizedBox(width: 16),
            // Recording information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                    'Recording as ${controller.currentNarrator.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: controller.recordingProgress.value,
                            backgroundColor: Colors.red.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 8,
                          ),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Obx(() => Text(
                        controller.recordingTime.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Stop button
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.stop, color: AppColors.recording, size: 24),
                onPressed: controller.stopRecording,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingRecordingIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 1.3),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      onEnd: () {
        // Reverse the animation when it completes
        // This creates a continuous pulsing effect
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}