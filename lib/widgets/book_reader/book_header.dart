import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/config/app_colors.dart';
import 'package:storybook/routes/app_routes.dart';

class BookHeader extends StatelessWidget {
  final BookReaderController controller = Get.find<BookReaderController>();

  BookHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button with nicer styling
          _buildCircleButton(
            icon: Icons.arrow_back,
            onPressed: () => Get.offNamed(AppRoutes.HOME),
            color: AppColors.primary,
          ),

          // Page indicator (doubles as thumbnails toggle)
          Obx(() => GestureDetector(
            onTap: controller.toggleThumbnails,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
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
                children: [
                  Text(
                    '${controller.currentPage.value + 1}/${controller.totalPages}',
                    style: const TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    controller.showThumbnails.value
                        ? Icons.grid_off
                        : Icons.grid_view,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          )),

          // Background music control (improved visibility)
          Obx(() => _buildCircleButton(
            icon: controller.isMusicPlaying.value
                ? Icons.music_note
                : Icons.music_off,
            onPressed: controller.toggleBackgroundMusic,
            color: controller.isMusicPlaying.value
                ? AppColors.primary
                : Colors.grey,
          )),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}