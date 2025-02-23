import 'package:get/get.dart';
import 'package:storybook/Model/BookReader.dart';

class BookReaderController extends GetxController {
  final RxInt currentPage = 0.obs;
  final List<BookPage> pages = [
    BookPage(
      content: 'Once upon a time, a magical tree grew in the forest...',
      imageUrl: 'https://placehold.co/300x400/FF6F61/FFFFFF/png?text=Page+1',
    ),
    BookPage(
      content: 'The tree sparkled with golden leaves under the moonlight...',
      imageUrl: 'https://placehold.co/300x400/6B7280/FFFFFF/png?text=Page+2',
    ),
    BookPage(
      content: 'Children from the village came to play and discover its secrets...',
      imageUrl: 'https://placehold.co/300x400/4CAF50/FFFFFF/png?text=Page+3',
    ),
  ];

  void updatePage(int page) {
    currentPage.value = page;
  }

  int get totalPages => pages.length;
}