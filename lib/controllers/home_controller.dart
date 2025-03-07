import "package:get/get.dart";
import "package:storybook/services/auth_service.dart";
import "package:storybook/models/book.dart";

class HomeController extends GetxController {
  RxList<Book> books = <Book>[].obs;
  RxList<Book> filteredBooks = <Book>[].obs;
  RxString searchQuery = "".obs;
  RxString selectedCategory = "All".obs;
  RxString selectedAgeRange = "All".obs; // Added selected age range
  RxString selectedValue = "All".obs; // Added selected value

  @override
  void onInit() {
    super.onInit();
    loadMockBooks();
    filteredBooks.assignAll(books); // Initially show all books
  }

  void loadMockBooks() {
    // Create a diverse set of books with different categories, age ranges, values, etc.
    books.assignAll([
      // Adventure Books
      Book(
        title: "The Girl and the Giant Friends",
        author: "Ella Story",
        thumbnailUrl: "assets/images/luna_title.png",
        category: "Adventure",
        ageRange: "6-8",
        values: ["Friendship", "Courage"],
      ),
      Book(
        title: "Mountain Explorer",
        author: "Rohan Trekker",
        thumbnailUrl: "assets/images/luna_1.png",
        category: "Adventure",
        ageRange: "9-12",
        values: ["Courage", "Perseverance"],
        isPremium: true,
      ),
      Book(
        title: "Oceans of Wonder",
        author: "Marina Deep",
        thumbnailUrl: "assets/images/luna_2.png",
        category: "Adventure",
        ageRange: "3-5",
        values: ["Curiosity", "Friendship"],
      ),

      // Fantasy Books
      Book(
        title: "The Dragon's Egg",
        author: "Merlin Wizard",
        thumbnailUrl: "assets/images/luna_3.png",
        category: "Fantasy",
        ageRange: "6-8",
        values: ["Courage", "Kindness"],
      ),
      Book(
        title: "Fairy Kingdom",
        author: "Pixie Dust",
        thumbnailUrl: "assets/images/luna_4.png",
        category: "Fantasy",
        ageRange: "3-5",
        values: ["Kindness", "Honesty"],
        isPremium: true,
      ),
      Book(
        title: "Wizard's Apprentice",
        author: "Gandolf Grey",
        thumbnailUrl: "assets/images/luna_5.png",
        category: "Fantasy",
        ageRange: "9-12",
        values: ["Perseverance", "Wisdom"],
      ),

      // Animal Books
      Book(
        title: "Jungle Friends",
        author: "Leo Lion",
        thumbnailUrl: "assets/images/luna_6.png",
        category: "Animals",
        ageRange: "3-5",
        values: ["Friendship", "Kindness"],
      ),
      Book(
        title: "Dolphin's Journey",
        author: "Splash Aqua",
        thumbnailUrl: "assets/images/luna_7.png",
        category: "Animals",
        ageRange: "6-8",
        values: ["Courage", "Friendship"],
        isPremium: true,
      ),
      Book(
        title: "Panda's Bamboo",
        author: "Bamboo Bear",
        thumbnailUrl: "assets/images/luna_8.png",
        category: "Animals",
        ageRange: "3-5",
        values: ["Sharing", "Kindness"],
      ),

      // Sci-Fi Books
      Book(
        title: "Space Explorers",
        author: "Nova Star",
        thumbnailUrl: "assets/images/luna_9.png",
        category: "Sci-Fi",
        ageRange: "9-12",
        values: ["Curiosity", "Courage"],
      ),
      Book(
        title: "Robot Friends",
        author: "Tech Bot",
        thumbnailUrl: "assets/images/luna_10.png",
        category: "Sci-Fi",
        ageRange: "6-8",
        values: ["Friendship", "Kindness"],
        isPremium: true,
      ),
      Book(
        title: "Alien Buddies",
        author: "Galaxy Green",
        thumbnailUrl: "assets/images/luna_1.png", // Reusing image for demo
        category: "Sci-Fi",
        ageRange: "3-5",
        values: ["Friendship", "Acceptance"],
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

  void filterByAgeRange(String ageRange) {
    selectedAgeRange.value = ageRange;
    filterBooks();
  }

  void filterByValue(String value) {
    selectedValue.value = value;
    filterBooks();
  }

  void filterBooks() {
    if (searchQuery.value.isEmpty &&
        selectedCategory.value == "All" &&
        selectedAgeRange.value == "All" &&
        selectedValue.value == "All") {
      // No filters active, show all books
      filteredBooks.assignAll(books);
      return;
    }

    filteredBooks.assignAll(books.where((book) {
      // Check if book matches the search query
      final matchesSearch = searchQuery.value.isEmpty ||
          book.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.value.toLowerCase());

      // Check if book matches the selected category
      final matchesCategory = selectedCategory.value == "All" ||
          book.category == selectedCategory.value;

      // Check if book matches the selected age range
      final matchesAgeRange = selectedAgeRange.value == "All" ||
          book.ageRange == selectedAgeRange.value;

      // Check if book contains the selected value
      final matchesValue = selectedValue.value == "All" ||
          book.values.contains(selectedValue.value);

      // Book must match all active filters
      return matchesSearch && matchesCategory && matchesAgeRange && matchesValue;
    }).toList());
  }

  void logout() {
    Get.find<AuthService>().logout();
  }
}