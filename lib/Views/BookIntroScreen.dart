import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/Views/BookReaderScreen.dart';
import 'package:storybook/Controller/BookReaderController.dart';

class BookIntroScreen extends StatelessWidget {
  final String bookTitle;
  final String bookCoverUrl;

  const BookIntroScreen({
    Key? key,
    required this.bookTitle,
    required this.bookCoverUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure BookReaderController is initialized
    Get.put(BookReaderController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bookCoverUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Home Button
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: IconButton(
                        icon: const Icon(Icons.home, color: Colors.blue),
                        onPressed: () => Get.offNamed('/home'),
                      ),
                    ),
                    // Mute Button
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: IconButton(
                        icon: const Icon(Icons.volume_off, color: Colors.blue),
                        onPressed: () {
                          // Toggle sound logic here
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Book Options
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Read Button
                  _buildOptionButton(
                    icon: Icons.menu_book,
                    label: 'Read',
                    color: Colors.blue,
                    onTap: () => Get.to(() => BookReaderScreen()),
                  ),
                  const SizedBox(height: 16),
                  // Listen Button
                  _buildOptionButton(
                    icon: Icons.headphones,
                    label: 'Listen',
                    color: Colors.orange,
                    onTap: () => _showListenOptions(),
                  ),
                  const SizedBox(height: 16),
                  // Record Button
                  _buildOptionButton(
                    icon: Icons.mic,
                    label: 'Record',
                    color: Colors.deepOrange.shade300,
                    onTap: () => _showRecordOptions(),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Baloo',
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showListenOptions() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Professional voice-over',
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 24,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVoiceOption(
              icon: Icons.child_care,
              name: 'Jasper',
              onTap: () {
                // Logic to set voice and start listening
                Get.back();
                Get.to(() => BookReaderScreen(isListening: true, narratorName: 'Jasper'));
              },
            ),
            const SizedBox(height: 8),
            _buildVoiceOption(
              icon: Icons.record_voice_over,
              name: 'Nick Zhurov',
              onTap: () {
                // Logic to set voice and start listening
                Get.back();
                Get.to(() => BookReaderScreen(isListening: true, narratorName: 'Nick Zhurov'));
              },
            ),
            const Divider(height: 24),
            const Text(
              'My voice-overs',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'You haven\'t voice-overed this story yet',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceOption({
    required IconData icon,
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green.shade800),
            const SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecordOptions() {
    final TextEditingController nameController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'New recording',
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 24,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Narrator\'s name:',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate name and start recording
                if (nameController.text.isNotEmpty) {
                  Get.back();
                  Get.to(() => BookReaderScreen(
                    isRecording: true,
                    narratorName: nameController.text,
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Start',
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Drafts',
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Sample drafts list
            _buildDraftItem(name: 'cipet', onTap: () {}),
            const SizedBox(height: 8),
            _buildDraftItem(name: 'bagong', onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftItem({
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.child_care, color: Colors.orange.shade800),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: Colors.orange.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}