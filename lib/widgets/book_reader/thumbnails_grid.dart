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

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header for thumbnails with better positioned close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                children: [
                  // Back button - added for better navigation
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: controller.toggleThumbnails,
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "All Pages",
                    style: TextStyle(
                      fontFamily: "Baloo",
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  // Close button with better contrast and accessibility
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: controller.toggleThumbnails,
                      tooltip: "Close thumbnails",
                    ),
                  ),
                ],
              ),
            ),

            // Thumbnails grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 5 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.totalPages,
                itemBuilder: (context, index) {
                  return _buildThumbnailItem(index);
                },
              ),
            ),

            // Footer with navigation buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Go to first page button
                  TextButton.icon(
                    onPressed: () {
                      controller.updatePage(0);
                      controller.toggleThumbnails();
                    },
                    icon: const Icon(Icons.first_page),
                    label: const Text("First Page"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Go to current page button
                  Obx(() => ElevatedButton.icon(
                    onPressed: () {
                      controller.toggleThumbnails();
                    },
                    icon: const Icon(Icons.visibility),
                    label: Text("Go to Page ${controller.currentPage.value + 1}"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailItem(int index) {
    return GestureDetector(
      onTap: () {
        controller.updatePage(index);
        controller.toggleThumbnails();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
              ),
            )
                : null,
          ),

          // Page number badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Current page indicator
          Obx(() {
            if (controller.currentPage.value == index) {
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.amber,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}