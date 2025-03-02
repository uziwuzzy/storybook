import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/controllers/home_controller.dart";
import "package:storybook/config/app_colors.dart";
import "package:storybook/widgets/dialogs/premium_paywall_dialog.dart";
import "package:storybook/widgets/dialogs/settings_dialog.dart";
import "package:storybook/widgets/home/filter_section_tab.dart";
import "package:storybook/widgets/home/filter_chip_menu.dart";
import "package:storybook/widgets/home/book_card.dart";
import "package:storybook/widgets/common/circle_button.dart";
import "package:storybook/utils/ui_utils.dart";

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.find<HomeController>();
  final RxString _activeFilterSection = "Category".obs;
  final RxBool _isMusicPlaying = true.obs;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with overlay
          Positioned.fill(
            child: Image.asset(
              "assets/images/home_background.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient if image is missing
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

          // Light overlay to ensure content readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Enhanced header with profile and settings - using a custom widget
                _ResponsiveHeader(
                  controller: _controller,
                  isMusicPlaying: _isMusicPlaying,
                ),

                // Search and filters area with rounded corners
                _buildSearchAndFilters(),

                // Books Grid
                Expanded(
                  child: Obx(() {
                    if (_controller.filteredBooks.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildBooksGrid();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar with fun icon
          TextField(
            onChanged: _controller.searchBooks,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              hintText: "Find a magical story...",
              hintStyle: TextStyle(
                fontFamily: "Nunito",
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter section tabs in a scrollable row for smaller screens
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => Row(
              children: [
                FilterSectionTab(
                  label: "Category",
                  isSelected: _activeFilterSection.value == "Category",
                  onTap: () => _activeFilterSection.value = "Category",
                ),
                FilterSectionTab(
                  label: "Age",
                  isSelected: _activeFilterSection.value == "Age",
                  onTap: () => _activeFilterSection.value = "Age",
                ),
                FilterSectionTab(
                  label: "Values",
                  isSelected: _activeFilterSection.value == "Values",
                  onTap: () => _activeFilterSection.value = "Values",
                ),
              ],
            )),
          ),

          const SizedBox(height: 12),

          // Filter chips based on selected section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              List<Widget> filterChips = [];

              // Always show "All" option first
              filterChips.add(
                FilterChipMenu(
                  label: "All",
                  isSelected: _controller.selectedCategory.value == "All",
                  onTap: () => _controller.filterByCategory("All"),
                  color: AppColors.primary,
                ),
              );

              // Add chips based on selected filter section
              if (_activeFilterSection.value == "Category") {
                filterChips.addAll(
                  ["Adventure", "Fantasy", "Animals", "Sci-Fi"].map((category) =>
                      FilterChipMenu(
                        label: category,
                        isSelected: _controller.selectedCategory.value == category,
                        onTap: () => _controller.filterByCategory(category),
                        color: UiUtils.getCategoryColor(category),
                      ),
                  ),
                );
              } else if (_activeFilterSection.value == "Age") {
                filterChips.addAll(
                  ["3-5", "6-8", "9-12"].map((age) =>
                      FilterChipMenu(
                        label: age,
                        isSelected: false, // Implement age filtering in the future
                        onTap: () => UiUtils.showComingSoonMessage("Age filter for $age years"),
                        color: Colors.teal,
                      ),
                  ),
                );
              } else if (_activeFilterSection.value == "Values") {
                filterChips.addAll(
                  ["Kindness", "Friendship", "Courage", "Honesty"].map((value) =>
                      FilterChipMenu(
                        label: value,
                        isSelected: false, // Implement values filtering in the future
                        onTap: () => UiUtils.showComingSoonMessage("$value filter"),
                        color: Colors.deepPurple,
                      ),
                  ),
                );
              }

              // Add Premium filter at the end
              filterChips.add(
                FilterChipMenu(
                  label: "Premium",
                  isSelected: false, // Implement premium filter if needed
                  onTap: () => PremiumPaywallDialog.show(),
                  color: Colors.amber,
                  icon: Icons.star,
                ),
              );

              return Row(children: filterChips);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = UiUtils.getGridColumns(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _controller.filteredBooks.length,
          itemBuilder: (context, index) {
            final book = _controller.filteredBooks[index];
            return BookCard(
              book: book,
              onTap: () {
                if (book.isPremium) {
                  // Show Paywall directly instead of the premium book dialog
                  PremiumPaywallDialog.show();
                } else {
                  UiUtils.navigateToBookIntro(book);
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/gambar1.png",
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          const Text(
            "No stories found!",
            style: TextStyle(
              fontFamily: "Baloo",
              fontSize: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Try a different search or category",
            style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _controller.filterByCategory("All"),
            icon: const Icon(Icons.refresh),
            label: const Text("Show all books"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A separate widget for the header to better isolate and fix layout issues
class _ResponsiveHeader extends StatelessWidget {
  final HomeController controller;
  final RxBool isMusicPlaying;

  const _ResponsiveHeader({
    Key? key,
    required this.controller,
    required this.isMusicPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine responsive behavior
    final double screenWidth = MediaQuery.of(context).size.width;

    // Adaptive layout based on screen width
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate available width
            final availableWidth = constraints.maxWidth;

            // Determine if we should show the title based on available space
            final bool canShowTitle = availableWidth > 300;
            final bool canShowProfile = availableWidth > 360;

            return Row(
              children: [
                // App icon (always shown)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                // App title - if space permits
                if (canShowTitle) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Storybook",
                      style: TextStyle(
                        fontFamily: "Baloo",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else ...[
                  // Add a spacer when title is hidden to push buttons to the right
                  const Spacer(),
                ],

                // Music toggle button
                Obx(() => CircleButton(
                  icon: isMusicPlaying.value ? Icons.music_note : Icons.music_off,
                  onPressed: () => isMusicPlaying.value = !isMusicPlaying.value,
                  color: isMusicPlaying.value ? AppColors.primary : Colors.grey,
                )),
                const SizedBox(width: 8),

                // Profile button - only show if space permits
                if (canShowProfile) ...[
                  CircleButton(
                    icon: Icons.person,
                    onPressed: () => UiUtils.showComingSoonMessage("Profile"),
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                ],

                // Settings button (always show)
                CircleButton(
                  icon: Icons.settings,
                  onPressed: () => SettingsDialog.show(controller),
                  color: AppColors.primary,
                ),
              ],
            );
          }
      ),
    );
  }
}