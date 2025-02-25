import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/Controller/HomeController.dart';
import 'package:storybook/Views/BookIntroScreen.dart';
import 'package:storybook/Views/BookReaderScreen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());
  final RxString _activeFilter = RxString('');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with improved hierarchy
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Title and Logout
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Storytime Magic',
                          style: TextStyle(
                            fontFamily: 'Baloo',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.black54),
                          onPressed: _controller.logout,
                        ),
                      ],
                    ),
                  ),

                  // Search Bar with proper spacing
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: TextField(
                      onChanged: _controller.searchBooks,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        hintText: 'Search for magical stories...',
                        hintStyle: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  // Filter Bar with improved visuals
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Obx(() => Row(
                      children: filters.entries.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FilterDropdown(
                            label: filter.key,
                            options: filter.value,
                            isActive: _activeFilter.value == filter.key,
                            onTap: () {
                              _activeFilter.value =
                              _activeFilter.value == filter.key ? '' : filter.key;
                            },
                            onOptionSelected: (value) {
                              if (filter.key == 'Category') {
                                _controller.filterByCategory(value);
                              }
                              _activeFilter.value = '';
                            },
                          ),
                        );
                      }).toList(),
                    )),
                  ),
                ],
              ),
            ),

            // Books Grid with improved spacing
            Expanded(
              child: Obx(() {
                if (_controller.filteredBooks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No stories found!',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = getGridColumns(constraints.maxWidth);

                    return GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3/4,
                      ),
                      itemCount: _controller.filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _controller.filteredBooks[index];
                        return BookCard(book: book);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
            () => BookIntroScreen(
          bookTitle: book.title,
          bookCoverUrl: book.thumbnailUrl,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Book Cover with error handling
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
            // Gradient Overlay
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
            // Premium Badge
            if (book.isPremium)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Premium',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
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
}

class FilterDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final bool isActive;
  final VoidCallback onTap;
  final Function(String) onOptionSelected;

  const FilterDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.isActive,
    required this.onTap,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: isActive ? Colors.blue.shade500 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isActive ? Colors.white : Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.map((option) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(option),
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
      ],
    );
  }
}