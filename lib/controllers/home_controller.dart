import "package:get/get.dart";
import "package:storybook/services/auth_service.dart";
import "package:storybook/models/book.dart";

class HomeController extends GetxController {
  RxList<Book> books = <Book>[].obs;
  RxList<Book> filteredBooks = <Book>[].obs;
  RxString searchQuery = "".obs;
  RxString selectedCategory = "All".obs;

  @override
  void onInit() {
    super.onInit();
    loadMockBooks();
    filteredBooks.assignAll(books); // Initially show all books
  }

  void loadMockBooks() {
    // Create a diverse set of books with different categories, premium status, etc.
    books.assignAll([
      // Adventure Books
      Book(
        title: "The Girl and the Giant Friends",
        author: "Ella Story",
        thumbnailUrl: "assets/images/luna_title.png",
        category: "Adventure",
      ),
      Book(
        title: "Mountain Explorer",
        author: "Rohan Trekker",
        thumbnailUrl: "assets/images/luna_1.png",
        category: "Adventure",
        isPremium: true,
      ),
      Book(
        title: "Oceans of Wonder",
        author: "Marina Deep",
        thumbnailUrl: "assets/images/luna_2.png",
        category: "Adventure",
      ),

      // Fantasy Books
      Book(
        title: "The Dragon's Egg",
        author: "Merlin Wizard",
        thumbnailUrl: "assets/images/luna_3.png",
        category: "Fantasy",
      ),
      Book(
        title: "Fairy Kingdom",
        author: "Pixie Dust",
        thumbnailUrl: "assets/images/luna_4.png",
        category: "Fantasy",
        isPremium: true,
      ),
      Book(
        title: "Wizard's Apprentice",
        author: "Gandolf Grey",
        thumbnailUrl: "assets/images/luna_5.png",
        category: "Fantasy",
      ),

      // Animal Books
      Book(
        title: "Jungle Friends",
        author: "Leo Lion",
        thumbnailUrl: "assets/images/luna_6.png",
        category: "Animals",
      ),
      Book(
        title: "Dolphin's Journey",
        author: "Splash Aqua",
        thumbnailUrl: "assets/images/luna_7.png",
        category: "Animals",
        isPremium: true,
      ),
      Book(
        title: "Panda's Bamboo",
        author: "Bamboo Bear",
        thumbnailUrl: "assets/images/luna_8.png",
        category: "Animals",
      ),

      // Sci-Fi Books
      Book(
        title: "Space Explorers",
        author: "Nova Star",
        thumbnailUrl: "assets/images/luna_9.png",
        category: "Sci-Fi",
      ),
      Book(
        title: "Robot Friends",
        author: "Tech Bot",
        thumbnailUrl: "assets/images/luna_10.png",
        category: "Sci-Fi",
        isPremium: true,
      ),
      Book(
        title: "Alien Buddies",
        author: "Galaxy Green",
        thumbnailUrl: "assets/images/luna_1.png", // Reusing image for demo
        category: "Sci-Fi",
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
    if (searchQuery.value.isEmpty && selectedCategory.value == "All") {
      // No filters active, show all books
      filteredBooks.assignAll(books);
      return;
    }

    filteredBooks.assignAll(books.where((book) {
      final matchesSearch = searchQuery.value.isEmpty ||
          book.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesCategory = selectedCategory.value == "All" ||
          book.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList());
  }

  void logout() {
    Get.find<AuthService>().logout();
  }
}