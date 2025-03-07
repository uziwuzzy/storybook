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

    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600; // Detect if device is a tablet

    // Responsive font size - larger on tablets
    final double fontSize = isTablet ? 26.0 : 20.0;

    // Responsive container height - take up more space for text (up to half the screen)
    final double containerHeight = screenSize.height / 2; // Take 50% of screen height

    // Use a ScrollController to properly handle the scrollbar
    final ScrollController scrollController = ScrollController();

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

        // Text container at the bottom with gradient overlay for better readability
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: containerHeight,
            decoration: BoxDecoration(
              // Gradient background that fades from transparent to black
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.3, 0.7],
              ),
            ),
            child: SafeArea(
              bottom: true, // Only apply safe area to the bottom
              child: Padding(
                padding: EdgeInsets.only(
                  top: containerHeight * 0.2, // Start text after the gradient starts to darken
                  bottom: 20,
                  left: isTablet ? 40 : 24,
                  right: isTablet ? 40 : 24,
                ),
                child: Center(
                  child: RawScrollbar(
                    thumbColor: Colors.white30,
                    controller: scrollController,
                    thickness: 4,
                    radius: const Radius.circular(8),
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, bottom: 16), // Add padding for scrollbar
                        child: Text(
                          page.content,
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: fontSize,
                            height: 1.5,
                            color: Colors.white,
                            // Add shadow for better readability
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Left navigation button with improved visibility
        Positioned(
          left: 0,
          top: screenSize.height / 2 - 40, // Center vertically in the screen
          child: Container(
            height: 40,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20, // Larger icon for better visibility
              ),
              onPressed: controller.currentPage.value > 0
                  ? controller.previousPage
                  : null,
            ),
          ),
        ),

        // Right navigation button with improved visibility
        Positioned(
          right: 0,
          top: screenSize.height / 2 - 40, // Center vertically in the screen
          child: Container(
            height: 40,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20, // Larger icon for better visibility
              ),
              onPressed: controller.nextPage,
            ),
          ),
        ),

        // Audio controls at the top (only for listening mode)
        if (isListening)
          _buildAudioControls(controller),

        // Recording indicator (only for recording mode)
        if (isRecording)
          _buildRecordingIndicator(controller),
      ],
    );
  }

  Widget _buildScrollableText(double fontSize) {
    // Use a ScrollController to properly handle the scrollbar
    final ScrollController scrollController = ScrollController();

    // Create a scrollable container for text that handles vertical overflow
    return Scrollbar(
      controller: scrollController,
      thickness: 4,
      radius: const Radius.circular(8),
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 16), // Add padding for scrollbar
          child: Text(
            page.content,
            style: TextStyle(
              fontFamily: "Nunito",
              fontSize: fontSize,
              height: 1.5,
              color: Colors.white,
              // Add shadow for better readability
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(1),
                  blurRadius: 4,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioControls(BookReaderController controller) {
    return Positioned(
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
    );
  }

  Widget _buildRecordingIndicator(BookReaderController controller) {
    return Positioned(
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