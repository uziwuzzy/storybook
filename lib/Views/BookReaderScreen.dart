import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/Controller/BookReaderController.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:storybook/Model/BookReader.dart';

class BookReaderScreen extends StatelessWidget {
  final bool isListening;
  final bool isRecording;
  final String? narratorName;

  BookReaderScreen({
    Key? key,
    this.isListening = false,
    this.isRecording = false,
    this.narratorName,
  }) : super(key: key);

  final BookReaderController _controller = Get.find<BookReaderController>();

  @override
  Widget build(BuildContext context) {
    // Initialize mode (if coming from another screen)
    _initializeMode();

    return Scaffold(
      body: Obx(() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content (reading area)
              Column(
                children: [
                  // Navigation and Page Indicator Header
                  _buildHeader(),

                  // Book Content with Page Turning
                  Expanded(
                    child: _controller.showThumbnails.value
                        ? _buildThumbnailsGrid()
                        : _buildPageView(),
                  ),
                ],
              ),

              // Recording UI overlay (if in recording mode)
              if (_controller.isRecording.value)
                _buildRecordingOverlay(),
            ],
          ),
        ),
      )),
    );
  }

  void _initializeMode() {
    if (isListening && narratorName != null) {
      // Setup for listening mode
      _controller.currentNarrator.value = narratorName!;
      // Start auto-playing (in a real app, this would play actual audio)
      _controller.togglePlayPause();
    } else if (isRecording && narratorName != null) {
      // Setup for recording mode
      _controller.startRecording(narratorName!);
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),

          // Page indicator (doubles as thumbnails toggle)
          GestureDetector(
            onTap: _controller.toggleThumbnails,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Page ${_controller.currentPage.value + 1} of ${_controller.totalPages}',
                    style: const TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _controller.showThumbnails.value
                        ? Icons.grid_off
                        : Icons.grid_view,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          // Mode-specific controls
          _buildModeControls(),
        ],
      ),
    );
  }

  Widget _buildModeControls() {
    // Recording controls
    if (_controller.isRecording.value) {
      return IconButton(
        icon: Icon(
          _controller.isRecording.value
              ? Icons.stop_circle
              : Icons.mic,
          color: Colors.white,
        ),
        onPressed: _controller.stopRecording,
      );
    }

    // Listening controls
    if (isListening) {
      return IconButton(
        icon: Icon(
          _controller.isPlaying.value
              ? Icons.pause_circle_filled
              : Icons.play_circle_fill,
          color: Colors.white,
        ),
        onPressed: _controller.togglePlayPause,
      );
    }

    // Default (reading mode)
    return const SizedBox(width: 48);
  }

  Widget _buildPageView() {
    // Use a standard PageView with a custom page turn transition
    return PageView.builder(
      controller: _controller.pageController,
      itemCount: _controller.totalPages,
      onPageChanged: (index) => _controller.updatePage(index),
      itemBuilder: (context, index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildPage(_controller.pages[index]),
      ),
      // Use a custom physics for a more book-like feel
      physics: const PageScrollPhysics(),
    );
  }

  Widget _buildPage(BookPage page) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (page.imageUrl != null)
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16)
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16)
                  ),
                  child: Image.asset(
                    page.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Placeholder for missing images
                      return Center(
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
                              'Image for page ${_controller.pages.indexOf(page) + 1}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          page.content,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: _controller.currentPage.value > 0
                              ? Colors.black54
                              : Colors.black12,
                        ),
                        onPressed: _controller.currentPage.value > 0
                            ? _controller.previousPage
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: _controller.currentPage.value < _controller.totalPages - 1
                              ? Colors.black54
                              : Colors.black12,
                        ),
                        onPressed: _controller.currentPage.value < _controller.totalPages - 1
                            ? _controller.nextPage
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailsGrid() {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Pages',
            style: TextStyle(
              fontFamily: 'Baloo',
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _controller.totalPages,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _controller.updatePage(index);
                    _controller.toggleThumbnails();
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Thumbnail
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                          image: _controller.pages[index].imageUrl != null
                              ? DecorationImage(
                            image: AssetImage(_controller.pages[index].imageUrl!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _controller.pages[index].imageUrl == null
                            ? Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey.shade600,
                          ),
                        )
                            : null,
                      ),

                      // Page number
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Current page indicator
                      if (_controller.currentPage.value == index)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.yellow,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingOverlay() {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
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
            // Recording indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Recording information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Recording as ${_controller.currentNarrator.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _controller.recordingProgress.value,
                            backgroundColor: Colors.red.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _controller.recordingTime.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Stop button
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.white, size: 36),
              onPressed: _controller.stopRecording,
            ),
          ],
        ),
      ),
    );
  }
}