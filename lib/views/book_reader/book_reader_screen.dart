import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/widgets/book_reader/thumbnails_grid.dart';
import 'package:storybook/widgets/book_reader/book_page_widget.dart';

class BookReaderScreen extends StatelessWidget {
  BookReaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final BookReaderController controller = Get.find<BookReaderController>();

    // Get arguments from the route
    final arguments = Get.arguments as Map<String, dynamic>?;
    final bool isListening = arguments?['isListening'] ?? false;
    final bool isRecording = arguments?['isRecording'] ?? false;
    final String? narratorName = arguments?['narratorName'];

    // Initialize mode (if coming from another screen)
    _initializeMode(controller, isListening, isRecording, narratorName);

    return Scaffold(
      body: Obx(() {
        // Show either the thumbnails grid or the book page view
        if (controller.showThumbnails.value) {
          return ThumbnailsGrid();
        } else {
          return PageView.builder(
            controller: controller.pageController,
            itemCount: controller.totalPages,
            onPageChanged: (index) => controller.updatePage(index),
            itemBuilder: (context, index) => BookPageWidget(
              page: controller.pages[index],
              isListening: isListening,
              isRecording: isRecording && controller.isRecording.value,
            ),
          );
        }
      }),
    );
  }

  void _initializeMode(
      BookReaderController controller,
      bool isListening,
      bool isRecording,
      String? narratorName,
      ) {
    if (isListening && narratorName != null) {
      // Setup for listening mode
      controller.currentNarrator.value = narratorName;
      // Start auto-playing (in a real app, this would play actual audio)
      if (!controller.isPlaying.value) {
        controller.togglePlayPause();
      }
    } else if (isRecording && narratorName != null) {
      // Setup for recording mode
      controller.startRecording(narratorName);
    }
  }
}