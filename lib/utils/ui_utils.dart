import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/config/app_colors.dart';
import 'package:storybook/models/book.dart';
import 'package:storybook/routes/app_routes.dart';
import 'package:storybook/views/book_intro/book_intro_screen.dart';

class UiUtils {
  // Get color for category
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Adventure':
        return Colors.green;
      case 'Fantasy':
        return Colors.purple;
      case 'Animals':
        return Colors.orange;
      case 'Sci-Fi':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  // Calculate grid columns based on screen width
  static int getGridColumns(double width) {
    if (width >= 1280) return 4;
    if (width >= 768) return 3;
    return 2;
  }

  // Navigate to book intro screen
  static void navigateToBookIntro(Book book) {
    Get.to(
          () => BookIntroScreen(
        bookTitle: book.title,
        bookCoverUrl: book.thumbnailUrl,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Show coming soon message
  static void showComingSoonMessage(String feature) {
    Get.snackbar(
      'Coming Soon!',
      '$feature will be available in the next update!',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(
        Icons.celebration,
        color: Colors.white,
      ),
    );
  }

  // Show success message
  static void showSuccessMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }
}