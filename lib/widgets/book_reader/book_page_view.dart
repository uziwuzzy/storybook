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

  @override
  void initState() {
    super.initState();
    // Create the PageController here in initState
    _pageController = PageController(initialPage: controller.currentPage.value);

    // Listen for changes to the current page and update the controller's value
    _pageController!.addListener(_updateControllerPage);
  }

  void _updateControllerPage() {
    if (_pageController != null &&
        _pageController!.positions.isNotEmpty &&
        _pageController!.page != null) {
      final currentPage = _pageController!.page!.round();
      if (currentPage != controller.currentPage.value) {
        controller.updatePage(currentPage);
      }
    }
  }

  @override
  void dispose() {
    // Properly remove listener and dispose of PageController
    _pageController?.removeListener(_updateControllerPage);
    _pageController?.dispose();
    _pageController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Set up listener in build method for current page
    // This is safer than using Obx for PageController animations
    final currentPage = controller.currentPage.value;

    // If the controller page changed from elsewhere, animate to it
    if (_pageController != null &&
        _pageController!.hasClients &&
        currentPage != _pageController!.page?.round()) {
      // Schedule animation after the current build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController != null && _pageController!.hasClients) {
          _pageController!.animateToPage(
            currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: controller.totalPages,
      physics: const ClampingScrollPhysics(), // Prevent multi-page scrolling
      itemBuilder: (context, index) => Obx(() => BookPageWidget(
        page: controller.pages[index],
        isListening: widget.isListening,
        isRecording: widget.isRecording && controller.isRecording.value,
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}