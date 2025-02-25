import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/views/book_intro/book_intro_screen.dart';
import 'package:storybook/controllers/home_controller.dart';
import 'package:storybook/config/app_colors.dart';
import 'package:storybook/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.find<HomeController>();
  final RxString _activeFilter = RxString('');
  final RxBool _isMusicPlaying = true.obs;

  final Map<String, List<String>> filters = {
    'Age': ['3-5', '6-8', '9-12'],
    'Values': ['Kindness', 'Friendship', 'Courage', 'Honesty'],
    'Category': ['Adventure', 'Fantasy', 'Animals', 'Sci-Fi']
  };

  int getGridColumns(double width) {
    if (width >= 1280) return 4;
    if (width >= 768) return 3;
    return 2;
  }

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_background.png', // Add this image to your assets
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
              color: Colors.white.withOpacity(0.4),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Enhanced header with profile and settings
                _buildHeader(),

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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and title
          Row(
            children: [
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
              const SizedBox(width: 12),
              const Text(
                'Storytime Magic',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          // Header buttons (Music toggle, Profile, Settings)
          Row(
            children: [
              // Music toggle button
              Obx(() => _buildCircleButton(
                icon: _isMusicPlaying.value ? Icons.music_note : Icons.music_off,
                onPressed: () => _isMusicPlaying.value = !_isMusicPlaying.value,
                color: _isMusicPlaying.value ? AppColors.primary : Colors.grey,
              )),
              const SizedBox(width: 8),

              // Profile button
              _buildCircleButton(
                icon: Icons.person,
                onPressed: () => _showComingSoonMessage('Profile'),
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),

              // Settings button (shows menu)
              _buildCircleButton(
                icon: Icons.settings,
                onPressed: _showSettingsMenu,
                color: AppColors.primary,
              ),
            ],
          ),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
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
              hintText: 'Find a magical story...',
              hintStyle: TextStyle(
                fontFamily: 'Nunito',
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

          // Filter chips with colorful design
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => Row(
              children: [
                _buildFilterChip(
                  label: 'All',
                  isSelected: _controller.selectedCategory.value == 'All',
                  onTap: () => _controller.filterByCategory('All'),
                  color: AppColors.primary,
                ),
                ...['Adventure', 'Fantasy', 'Animals', 'Sci-Fi'].map((category) =>
                    _buildFilterChip(
                      label: category,
                      isSelected: _controller.selectedCategory.value == category,
                      onTap: () => _controller.filterByCategory(category),
                      color: _getCategoryColor(category),
                    ),
                ),
                _buildFilterChip(
                  label: 'Premium',
                  isSelected: false, // Implement premium filter if needed
                  onTap: () => _showComingSoonMessage('Premium filter'),
                  color: Colors.amber,
                  icon: Icons.star,
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = getGridColumns(constraints.maxWidth);

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
            return _buildBookCard(book);
          },
        );
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {
        if (book.isPremium) {
          _showPremiumDialog(book);
        } else {
          _navigateToBookIntro(book);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Book Cover
            Image.asset(
              book.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.book,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),

            // Gradient Overlay for text readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Book Info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(book.category).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            book.category,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Premium lock icon
                        if (book.isPremium)
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/gambar1.png', // Use an existing image or add a new one
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          const Text(
            'No stories found!',
            style: TextStyle(
              fontFamily: 'Baloo',
              fontSize: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Try a different search or category',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _controller.filterByCategory('All'),
            icon: const Icon(Icons.refresh),
            label: const Text('Show all books'),
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

  void _navigateToBookIntro(Book book) {
    Get.to(
          () => BookIntroScreen(
        bookTitle: book.title,
        bookCoverUrl: book.thumbnailUrl,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _showPremiumDialog(Book book) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stars,
                  color: Colors.amber,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Unlock "${book.title}"',
                style: const TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This magical story is part of our premium collection!',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  _showComingSoonMessage('Premium subscription');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_open),
                    SizedBox(width: 8),
                    Text(
                      'Get Premium',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            // Menu title
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Menu options
            _buildSettingsOption(
              icon: Icons.person,
              label: 'My Profile',
              onTap: () {
                Get.back();
                _showComingSoonMessage('Profile');
              },
            ),
            const Divider(height: 1),
            _buildSettingsOption(
              icon: Icons.stars,
              label: 'Premium Subscription',
              onTap: () {
                Get.back();
                _showComingSoonMessage('Premium subscription');
              },
            ),
            const Divider(height: 1),
            _buildSettingsOption(
              icon: Icons.music_note,
              label: 'Sound Settings',
              onTap: () {
                Get.back();
                _showComingSoonMessage('Sound settings');
              },
            ),
            const Divider(height: 1),
            _buildSettingsOption(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
                Get.back();
                _showLogoutConfirmation();
              },
              isDestructive: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 16),
              const Text(
                'Leaving so soon?',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Stay',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonMessage(String feature) {
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

  Color _getCategoryColor(String category) {
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
}