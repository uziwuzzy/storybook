import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/config/app_colors.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookReaderController controller = Get.find<BookReaderController>();

    return Positioned(
      top: 70,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primary,
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
            // Play/Pause button
            Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Obx(() => IconButton(
                icon: Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: AppColors.primary,
                ),
                onPressed: controller.togglePlayPause,
              )),
            ),
            // Progress slider
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayColor: Colors.white.withOpacity(0.2),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: 0.5, // This would be the actual progress in a real implementation
                  onChanged: (value) {
                    // Seek to position in audio
                  },
                ),
              ),
            ),
            // Time display
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                '00:30', // This would be the actual time in a real implementation
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}