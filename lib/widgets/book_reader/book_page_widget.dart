import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/models/book_reader.dart";
import "package:storybook/controllers/book_reader_controller.dart";
import "package:storybook/config/app_colors.dart";

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

        // Text and navigation row at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            height: MediaQuery.of(context).size.height / 3, // Height is 1/3 of screen
            child: SafeArea(
              // Ensures content is within safe area on devices with notches
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Center(
                        child: Text(
                          page.content,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 22,
                            height: 1.5,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // Navigation controls
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left navigation arrow
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: currentPage > 1 ? controller.previousPage : null,
                        ),

                        // Page indicator
                        Text(
                          "$currentPage/$totalPages",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Right navigation arrow
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onPressed: controller.nextPage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

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
                      "00,0",
                      style: TextStyle(
                        fontFamily: "Baloo",
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
                      "Recording ${controller.recordingTime.value}",
                      style: const TextStyle(
                        fontFamily: "Baloo",
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
              "Image loading...",
              style: TextStyle(
                fontFamily: "Nunito",
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}