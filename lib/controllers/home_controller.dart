import 'package:get/get.dart';
import 'package:storybook/Services/auth_service.dart';
import 'package:storybook/models/book.dart';


class HomeController extends GetxController {
  RxList<Book> books = <Book>[].obs;
  RxList<Book> filteredBooks = <Book>[].obs;
  RxString searchQuery = ''.obs;
  RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockBooks();
    filteredBooks.assignAll(books); // Initially show all books
  }

  void loadMockBooks() {
    books.assignAll([
      Book(
        title: 'Title: The Girl and the Giant Friends',
        author: 'Ella Story',
        thumbnailUrl: 'assets/images/luna_title.png',
        category: 'Adventure',
      )
    ]);
    filteredBooks.assignAll(books);
  }

  void searchBooks(String query) {
    searchQuery.value = query;
    filterBooks();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    filterBooks();
  }

  void filterBooks() {
    filteredBooks.assignAll(books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesCategory = selectedCategory.value == 'All' || book.category == selectedCategory.value;
      return matchesSearch && matchesCategory;
    }).toList());
  }

  void logout() {
    Get.find<AuthService>().logout();
  }
}