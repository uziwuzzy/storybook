class BookPage {
  final String content;
  final String? imageUrl; // Image for each page
  final String? audioUrl; // Audio file for narration

  BookPage({
    required this.content,
    this.imageUrl,
    this.audioUrl
  });
}