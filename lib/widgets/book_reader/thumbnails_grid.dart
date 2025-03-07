import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/controllers/book_reader_controller.dart";
import "package:storybook/config/app_colors.dart";

class ThumbnailsGrid extends StatelessWidget {
  final BookReaderController controller = Get.find<BookReaderController>();

  ThumbnailsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to make layout responsive
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with overlay
          Positioned.fill(
            child: Image.asset(
              "assets/images/home_background.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade200,
                        Colors.purple.shade200,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Light overlay for better readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header bar with style matching book_reader
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button with circle design
                      _buildCircleButton(
                        icon: Icons.arrow_back,
                        onPressed: controller.toggleThumbnails,
                        color: AppColors.primary,
                      ),

                      // Page indicator (similar to book_reader)
                      Container(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Text(
                              "Page ${controller.currentPage.value + 1}/${controller.totalPages}",
                              style: const TextStyle(
                                fontFamily: "Baloo",
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                          ],
                        ),
                      ),

                      // Music control (to match book_reader)
                      _buildCircleButton(
                        icon: Icons.music_note,
                        onPressed: controller.toggleBackgroundMusic,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                // Grid of thumbnails
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 4 : 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: controller.totalPages,
                    itemBuilder: (context, index) {
                      return _buildThumbnailItem(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailItem(int index) {
    return GestureDetector(
      onTap: () {
        controller.updatePage(index);
        controller.toggleThumbnails();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Thumbnail
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: controller.pages[index].imageUrl != null
                      ? DecorationImage(
                    image: AssetImage(controller.pages[index].imageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: controller.pages[index].imageUrl == null
                    ? Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.grey.shade400,
                    size: 36,
                  ),
                )
                    : null,
              ),

              // Gradient overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // Page number
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Page ${index + 1}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Current page indicator with ribbon
              Obx(() {
                if (controller.currentPage.value == index) {
                  return Stack(
                    children: [
                      // Border to highlight current selection
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 7,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      // Ribbon in the top-right corner
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CustomPaint(
                            painter: RibbonPainter(),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
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

// Custom painter for drawing a ribbon
class RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.4, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}