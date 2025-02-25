import 'package:get/get.dart';
import 'package:storybook/controllers/book_reader_controller.dart';

class BookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookReaderController>(() => BookReaderController());
  }
}