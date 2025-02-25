import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/widgets/common/circle_button.dart';
import 'package:storybook/widgets/book_intro/option_button.dart';
import 'package:storybook/widgets/dialogs/listen_options_dialog.dart';
import 'package:storybook/widgets/dialogs/record_options_dialog.dart';
import 'package:storybook/config/app_colors.dart';
import 'package:storybook/routes/app_routes.dart';

class BookIntroScreen extends StatelessWidget {
  final String bookTitle;
  final String bookCoverUrl;

  const BookIntroScreen({
    Key? key,
    required this.bookTitle,
    required this.bookCoverUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure BookReaderController is initialized
    Get.put(BookReaderController());

    return Scaffold(
      body: Stack(
        children: [
          // Background image with overlay
          Positioned.fill(
            child: Image.asset(
              bookCoverUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Darkening overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top navigation
                _buildTopNavigation(),

                const Spacer(),

                // Options (Read, Listen, Record)
                _buildOptionsMenu(),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home button
          CircleButton(
            icon: Icons.home,
            onPressed: () => Get.offNamed(AppRoutes.HOME),
            color: AppColors.primary,
          ),

          // Book title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                bookTitle,
                style: const TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Background music toggle
          CircleButton(
            icon: Icons.music_note,
            onPressed: () {
              // Toggle background music
              Get.find<BookReaderController>().toggleBackgroundMusic();
            },
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsMenu() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OptionButton(
            icon: Icons.menu_book,
            label: 'Read',
            color: AppColors.primary,
            onPressed: () => Get.offNamed(AppRoutes.BOOK_READER),
          ),
          const SizedBox(height: 20),
          OptionButton(
            icon: Icons.headphones,
            label: 'Listen',
            color: AppColors.secondary,
            onPressed: _showListenOptions,
          ),
          const SizedBox(height: 20),
          OptionButton(
            icon: Icons.mic,
            label: 'Record',
            color: AppColors.recording,
            onPressed: _showRecordOptions,
          ),
        ],
      ),
    );
  }

  void _showListenOptions() {
    Get.dialog(const ListenOptionsDialog());
  }

  void _showRecordOptions() {
    Get.dialog(const RecordOptionsDialog());
  }
}