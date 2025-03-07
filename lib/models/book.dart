class Book {
  final String title;
  final String author;
  final String thumbnailUrl;
  final String category;
  final String ageRange; // Added age range
  final List<String> values; // Added values list
  final bool isPremium;

  Book({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.category,
    this.ageRange = "all", // Default age range
    this.values = const [], // Default empty values list
    this.isPremium = false,
  });
}