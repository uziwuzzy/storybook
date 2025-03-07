import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/controllers/home_controller.dart";
import "package:storybook/config/app_colors.dart";
import "package:storybook/widgets/dialogs/premium_paywall_dialog.dart";
import "package:storybook/widgets/dialogs/settings_dialog.dart";
import "package:storybook/widgets/home/book_card.dart";
import "package:storybook/widgets/common/circle_button.dart";
import "package:storybook/utils/ui_utils.dart";
// Import our new responsive search filters
import "package:storybook/widgets/home/responsive_search_filters.dart";

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.find<HomeController>();
  final RxString _activeFilterSection = "Category".obs;
  final RxBool _isMusicPlaying = true.obs;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check orientation for landscape-specific layout
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = MediaQuery.of(context).size.width > 600;

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

          // Main content - use different layouts for landscape vs portrait
          SafeArea(
            child: isLandscape && !isTablet
                ? _buildLandscapeLayout(context)
                : _buildPortraitLayout(context),
          ),
        ],
      ),
    );
  }

  // Portrait layout (vertical orientation)
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        // Header with app logo, settings, etc.
        _ResponsiveHeader(
          controller: _controller,
          isMusicPlaying: _isMusicPlaying,
        ),

        // Responsive search and filters
        ResponsiveSearchFilters(
          controller: _controller,
          activeFilterSection: _activeFilterSection,
        ),

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
    );
  }

  // Landscape layout (horizontal orientation)
  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      children: [
        // Header with app logo, settings, etc. - reduced padding
        _ResponsiveHeader(
          controller: _controller,
          isMusicPlaying: _isMusicPlaying,
          useCompactMode: true,
        ),

        // Responsive search and filters - already handles landscape
        ResponsiveSearchFilters(
          controller: _controller,
          activeFilterSection: _activeFilterSection,
        ),

        // Books Grid - takes remaining space
        Expanded(
          child: Obx(() {
            if (_controller.filteredBooks.isEmpty) {
              return _buildEmptyState();
            }
            return _buildBooksGrid();
          }),
        ),
      ],
    );
  }

  Widget _buildBooksGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine number of columns based on orientation and size
        final isLandscape = MediaQuery.of(Get.context!).orientation == Orientation.landscape;
        final width = constraints.maxWidth;

        // In landscape mode on phones, show more columns
        final columns = isLandscape
            ? UiUtils.getGridColumns(width) + 1 // Add one more column in landscape
            : UiUtils.getGridColumns(width);

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
    // Determine if we're in landscape mode for a more compact empty state
    final isLandscape = MediaQuery.of(Get.context!).orientation == Orientation.landscape;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Smaller image in landscape
            Image.asset(
              "assets/images/luna_title.png",
              width: isLandscape ? 100 : 150,
              height: isLandscape ? 100 : 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: isLandscape ? 100 : 150,
                  height: isLandscape ? 100 : 150,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
            SizedBox(height: isLandscape ? 16 : 24),
            const Text(
              "No stories found!",
              style: TextStyle(
                fontFamily: "Baloo",
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isLandscape ? 8 : 12),
            const Text(
              "Try a different search or category",
              style: TextStyle(
                fontFamily: "Nunito",
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: isLandscape ? 16 : 24),
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
      ),
    );
  }
}

/// A separate widget for the header to better isolate and fix layout issues
class _ResponsiveHeader extends StatelessWidget {
  final HomeController controller;
  final RxBool isMusicPlaying;
  final bool useCompactMode; // For landscape orientation

  const _ResponsiveHeader({
    Key? key,
    required this.controller,
    required this.isMusicPlaying,
    this.useCompactMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adaptive layout based on screen width
    return Container(
      padding: EdgeInsets.fromLTRB(
          16,
          useCompactMode ? 8 : 12,
          16,
          useCompactMode ? 4 : 0
      ),
      child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate available width
            final availableWidth = constraints.maxWidth;

            // Determine if we should show the title based on available space
            final bool canShowTitle = availableWidth > 300;
            final bool canShowProfile = availableWidth > 360;

            return Row(
              children: [
                // App icon (always shown, but smaller in compact mode)
                Container(
                  width: useCompactMode ? 40 : 48,
                  height: useCompactMode ? 40 : 48,
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
                  child: Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                    size: useCompactMode ? 22 : 28,
                  ),
                ),

                // App title - if space permits
                if (canShowTitle) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Storybook",
                      style: TextStyle(
                        fontFamily: "Baloo",
                        fontSize: useCompactMode ? 20 : 24,
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
                if (canShowProfile && !useCompactMode) ...[
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