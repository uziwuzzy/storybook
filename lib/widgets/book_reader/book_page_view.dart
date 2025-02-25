import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';
import 'package:storybook/widgets/book_reader/book_page_widget.dart';

class BookPageView extends StatelessWidget {
  final bool isListening;
  final bool isRecording;
  final BookReaderController controller = Get.find<BookReaderController>();

  BookPageView({
    Key? key,
    this.isListening = false,
    this.isRecording = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      itemCount: controller.totalPages,
      onPageChanged: (index) => controller.updatePage(index),
      itemBuilder: (context, index) => BookPageWidget(
        page: controller.pages[index],
      ),
    );
  }
}