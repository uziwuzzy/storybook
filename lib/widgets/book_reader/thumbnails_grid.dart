import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/config/app_colors.dart';

class ThumbnailsGrid extends StatelessWidget {
  final BookReaderController controller = Get.find<BookReaderController>();

  ThumbnailsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header for thumbnails
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'All Pages',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: controller.toggleThumbnails,
                ),
              ],
            ),
          ),

          // Thumbnails grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: controller.totalPages,
              itemBuilder: (context, index) {
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
                            '${index + 1}',
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
                                  color: Colors.yellow,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(12),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}