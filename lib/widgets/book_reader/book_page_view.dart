import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/controllers/book_reader_controller.dart";
import "package:storybook/widgets/book_reader/book_page_widget.dart";

class BookPageView extends StatefulWidget {
  final bool isListening;
  final bool isRecording;

  const BookPageView({
    Key? key,
    this.isListening = false,
    this.isRecording = false,
  }) : super(key: key);

  @override
  State<BookPageView> createState() => _BookPageViewState();
}

class _BookPageViewState extends State<BookPageView> with AutomaticKeepAliveClientMixin {
  final BookReaderController controller = Get.find<BookReaderController>();
  PageController? _pageController;
  int _currentVisiblePage = 0; // Track the visible page locally

  @override
  void initState() {
    super.initState();
    // Initialize with the controller's current page
    _currentVisiblePage = controller.currentPage.value;

    // Create PageController with initial page
    _pageController = PageController(initialPage: _currentVisiblePage);

    // Add page change listener
    _pageController!.addListener(_handlePageChange);

    // Listen for external page change requests
    _setupPageChangeListener();
  }

  void _setupPageChangeListener() {
    // This worker will run whenever the controller's currentPage changes
    ever(controller.currentPage, (int page) {
      // Only animate if the page actually changed and we're not already on that page
      if (page != _currentVisiblePage && _pageController != null && _pageController!.hasClients) {
        // Use post-frame callback to avoid animation during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  void _handlePageChange() {
    if (_pageController != null &&
        _pageController!.hasClients &&
        _pageController!.positions.isNotEmpty &&
        _pageController!.page != null) {
      // Get the current page as an integer
      final newPage = _pageController!.page!.round();

      // Update local tracking variable
      if (newPage != _currentVisiblePage) {
        _currentVisiblePage = newPage;

        // Update the controller but avoid circular updates
        if (newPage != controller.currentPage.value) {
          controller.updatePage(newPage);
        }
      }
    }
  }

  @override
  void dispose() {
    // Clean up
    _pageController?.removeListener(_handlePageChange);
    _pageController?.dispose();
    _pageController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PageView.builder(
      controller: _pageController,
      itemCount: controller.totalPages,
      physics: const ClampingScrollPhysics(), // Prevent multi-page scrolling
      itemBuilder: (context, index) {
        // Use GetBuilder instead of Obx for more control
        return GetBuilder<BookReaderController>(
          builder: (ctrl) => BookPageWidget(
            page: ctrl.pages[index],
            isListening: widget.isListening,
            isRecording: widget.isRecording && ctrl.isRecording.value,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}