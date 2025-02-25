import 'package:get/get.dart';
import 'package:storybook/Services/auth_service.dart';

class Book {
  final String title;
  final String author;
  final String thumbnailUrl;
  final String category;
  final bool isPremium;

  Book({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.category,
    this.isPremium = false,
  });
}

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
        title: 'The Magic Tree',
        author: 'Ella Story',
        thumbnailUrl: 'assets/images/gambar1.png',
        category: 'Adventure',
      ),
      Book(
        title: 'Dino Friends',
        author: 'Rexy Roar',
        thumbnailUrl: 'assets/images/gambar2.png',
        category: 'Animals',
      ),
      Book(
        title: 'Space Pals',
        author: 'Starry Sky',
        thumbnailUrl: 'assets/images/gambar3.png',
        category: 'Sci-Fi',
        isPremium: true,
      ),
      Book(
        title: 'Fairy Dust',
        author: 'Tina Sparkle',
        thumbnailUrl: 'assets/images/gambar4.png',
        category: 'Fantasy',
      ),
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