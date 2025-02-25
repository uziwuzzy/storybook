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