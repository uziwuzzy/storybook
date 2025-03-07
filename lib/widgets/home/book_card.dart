import "package:flutter/material.dart";
import "package:storybook/models/book.dart";
import "package:storybook/utils/ui_utils.dart";

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({
    Key? key,
    required this.book,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if we're in landscape mode
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isSmallDevice = MediaQuery.of(context).size.width < 600;

    // Use more compact style in landscape mode on phones
    final useCompactMode = isLandscape && isSmallDevice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(useCompactMode ? 16 : 20),
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
                    size: useCompactMode ? 36 : 48,
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
                padding: EdgeInsets.all(useCompactMode ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontFamily: "Baloo",
                        fontSize: useCompactMode ? 14 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: useCompactMode ? 2 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: useCompactMode ? 4 : 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: useCompactMode ? 6 : 10,
                            vertical: useCompactMode ? 3 : 5,
                          ),
                          decoration: BoxDecoration(
                            color: UiUtils.getCategoryColor(book.category).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(useCompactMode ? 8 : 12),
                          ),
                          child: Text(
                            book.category,
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: useCompactMode ? 10 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Premium lock icon
                        if (book.isPremium)
                          Container(
                            width: useCompactMode ? 28 : 36,
                            height: useCompactMode ? 28 : 36,
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: useCompactMode ? 16 : 20,
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
}