import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/models/book_reader.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/routes/app_routes.dart';
import 'package:storybook/config/app_colors.dart';

class BookPageWidget extends StatelessWidget {
  final BookPage page;
  final bool isListening;
  final bool isRecording;

  const BookPageWidget({
    Key? key,
    required this.page,
    this.isListening = false,
    this.isRecording = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookReaderController controller = Get.find<BookReaderController>();
    final int currentPage = controller.currentPage.value + 1;
    final int totalPages = controller.totalPages;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-screen background image
        if (page.imageUrl != null)
          Image.asset(
            page.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildImagePlaceholder();
            },
          )
        else
          _buildImagePlaceholder(),

        // Text overlay at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Text(
              page.content,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                height: 1.5,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Removed page indicators as they're now in the BookHeader

        // Audio controls at the top (only for listening mode)
        if (isListening)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                          controller.isPlaying.value
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.white),
                      onPressed: controller.togglePlayPause,
                    ),
                    const Text(
                      '00,0',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: controller.nextPage,
                    ),
                  ],
                )),
              ),
            ),
          ),

        // Recording indicator (only for recording mode)
        if (isRecording)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.recording,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic, color: Colors.white),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                      'Recording ${controller.recordingTime.value}',
                      style: const TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.stop_circle, color: Colors.white),
                      onPressed: controller.stopRecording,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Home and Music buttons removed as they're now in the BookHeader

        // Navigation arrows aligned with the text area
        Positioned(
          left: 0,
          bottom: 85, // Aligned with the text area
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 40,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: currentPage > 1 ? controller.previousPage : null,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 85, // Aligned with the text area
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 40,
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: currentPage < totalPages ? controller.nextPage : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Image loading...',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}