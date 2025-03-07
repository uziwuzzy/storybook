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
  int _currentVisiblePage = 0;

  @override
  void initState() {
    super.initState();
    _currentVisiblePage = controller.currentPage.value;
    _pageController = PageController(initialPage: _currentVisiblePage);
    _setupPageChangeListener();
  }

  void _setupPageChangeListener() {
    ever(controller.currentPage, (int page) {
      if (page != _currentVisiblePage && _pageController != null && _pageController!.hasClients) {
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

  @override
  void dispose() {
    _pageController?.dispose();
    _pageController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Listener(
      onPointerUp: (event) {
        if (_currentVisiblePage == controller.totalPages - 1 &&
            _pageController != null &&
            _pageController!.position.pixels > _pageController!.position.maxScrollExtent) {
          controller.displayEndingOverlay();
        }
      },
      child: PageView.builder(
        controller: _pageController,
        itemCount: controller.totalPages,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (int page) {
          _currentVisiblePage = page;
          if (page != controller.currentPage.value) {
            controller.updatePage(page);
          }
        },
        itemBuilder: (context, index) {
          return GetBuilder<BookReaderController>(
            builder: (ctrl) => BookPageWidget(
              page: ctrl.pages[index],
              isListening: widget.isListening,
              isRecording: widget.isRecording && ctrl.isRecording.value,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}