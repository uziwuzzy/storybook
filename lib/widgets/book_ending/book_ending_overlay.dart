import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:storybook/config/app_colors.dart";
import "package:storybook/routes/app_routes.dart";

class BookEndingOverlay extends StatelessWidget {
  final String authorName;
  final String illustratorName;
  final String composerName;
  final VoidCallback? onRestartBook;

  const BookEndingOverlay({
    Key? key,
    this.authorName = "ALTAI ZEINALOV",
    this.illustratorName = "ANNA GORLACH",
    this.composerName = "ARTEM AKMULIN",
    this.onRestartBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxInt rating = 0.obs;
    final overlayColor = Colors.indigo.shade900.withOpacity(0.95);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Full screen background
          Positioned.fill(
            child: Container(
              color: overlayColor,
            ),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Decorative stars background
                _buildStarsBackground(),

                // Main content
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 40,
                      left: 24,
                      right: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Action buttons
                        _buildActionButton(
                          icon: Icons.share,
                          label: "Share",
                          color: Colors.blue,
                          onTap: () {
                            Get.snackbar(
                              "Share",
                              "Sharing functionality would go here",
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildActionButton(
                          icon: Icons.menu_book,
                          label: "To the beginning",
                          color: Colors.lightBlue,
                          onTap: () {
                            Get.back();
                            if (onRestartBook != null) {
                              onRestartBook!();
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildActionButton(
                          icon: Icons.home,
                          label: "To the library",
                          color: Colors.orange,
                          onTap: () {
                            Get.offAllNamed(AppRoutes.HOME);
                          },
                        ),
                        const SizedBox(height: 40),

                        // Rating stars
                        Text(
                          "How was the story?",
                          style: TextStyle(
                            fontFamily: "Baloo",
                            fontSize: 24,
                            color: Colors.amber.shade300,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Simple star rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Obx(() => GestureDetector(
                              onTap: () => rating.value = index + 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  index < rating.value ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              ),
                            ));
                          }),
                        ),
                        const SizedBox(height: 40),

                        // Credits section
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Container(
                              width: 1,
                              height: 180,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Featuring:",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Baloo",
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildCredit("Author", authorName),
                                    const SizedBox(height: 15),
                                    _buildCredit("Illustrator", illustratorName),
                                    const SizedBox(height: 15),
                                    _buildCredit("Composer", composerName),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // Close button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarsBackground() {
    return Stack(
      children: List.generate(30, (index) {
        return Positioned(
          left: (index * 30) % 400,
          top: (index * 25) % 800,
          child: Icon(
            Icons.star,
            color: Colors.white.withOpacity(0.2 + (index % 3) * 0.1),
            size: 8.0 + (index % 5) * 2,
          ),
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Baloo",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredit(String role, String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            role,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontFamily: "Nunito",
            ),
          ),
        ),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Baloo",
            ),
          ),
        ),
      ],
    );
  }
}