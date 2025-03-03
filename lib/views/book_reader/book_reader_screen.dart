import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/controllers/book_reader_controller.dart";
import "package:storybook/widgets/book_reader/thumbnails_grid.dart";
import "package:storybook/widgets/book_reader/book_page_view.dart";
import "package:storybook/widgets/book_reader/book_header.dart";
import "package:storybook/widgets/book_reader/recording_overlay.dart";
import "package:storybook/widgets/book_reader/audio_progress_bar.dart";

class BookReaderScreen extends StatelessWidget {
  const BookReaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final BookReaderController controller = Get.find<BookReaderController>();

    // Get arguments from the route
    final arguments = Get.arguments as Map<String, dynamic>?;
    final bool isListening = arguments?["isListening"] ?? false;
    final bool isRecording = arguments?["isRecording"] ?? false;
    final String? narratorName = arguments?["narratorName"];

    // Initialize mode (if coming from another screen)
    _initializeMode(controller, isListening, isRecording, narratorName);

    return Scaffold(
      body: Obx(() {
        // Show either the thumbnails grid or the book page view
        if (controller.showThumbnails.value) {
          // Show only the thumbnails grid when thumbnails are active
          return ThumbnailsGrid();
        } else {
          // Show the regular book reader UI with header and page view
          return _buildBookReader(
              controller: controller,
              isListening: isListening,
              isRecording: isRecording
          );
        }
      }),
    );
  }

  Widget _buildBookReader({
    required BookReaderController controller,
    required bool isListening,
    required bool isRecording,
  }) {
    return Stack(
      children: [
        // Main content - page view
        BookPageView(
          isListening: isListening,
          isRecording: isRecording,
        ),

        // Header at the top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: BookHeader(),
          ),
        ),

        // Audio progress bar when listening
        if (isListening && controller.isPlaying.value)
          const AudioProgressBar(),

        // Recording overlay when recording
        if (isRecording && controller.isRecording.value)
          const RecordingOverlay(),

        // We removed the floating action button for thumbnails here
        // since it's already accessible through the BookHeader
      ],
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