import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/Controller/BookReaderController.dart';
import 'package:storybook/Model/BookReader.dart';

class BookReaderScreen extends StatefulWidget {
  @override
  _BookReaderScreenState createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> with SingleTickerProviderStateMixin {
  final BookReaderController _controller = Get.put(BookReaderController());
  late AnimationController _animationController;
  late Animation<double> _animation;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _flipPage(bool forward) {
    if (forward && _controller.currentPage.value < _controller.totalPages - 1) {
      _animationController.forward().then((_) {
        _controller.updatePage(_controller.currentPage.value + 1);
        _animationController.reset();
      });
    } else if (!forward && _controller.currentPage.value > 0) {
      _animationController.forward().then((_) {
        _controller.updatePage(_controller.currentPage.value - 1);
        _animationController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Page indicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Page ${_controller.currentPage.value + 1} of ${_controller.totalPages}',
                      style: const TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Page view with custom flip animation
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx < -200) {
                      _flipPage(true); // Swipe left (next page)
                    } else if (details.velocity.pixelsPerSecond.dx > 200) {
                      _flipPage(false); // Swipe right (previous page)
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final angle = _animation.value * 3.14159 / 2; // 90-degree rotation
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // Perspective
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: _buildPage(_controller.pages[_controller.currentPage.value]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BookPage page) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (page.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  page.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Text(
                          'Image Error',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            Text(
              page.content,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}