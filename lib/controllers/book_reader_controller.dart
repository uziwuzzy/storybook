import "package:get/get.dart";
import "package:flutter/material.dart";
import "package:audioplayers/audioplayers.dart";
import "package:storybook/models/book_reader.dart";
import "package:storybook/widgets/book_ending/book_ending_overlay.dart";

class BookReaderController extends GetxController {
  // Page control
  final RxInt currentPage = 0.obs;
  late final PageController pageController;
  final RxBool showEndingOverlay = false.obs;

  // Audio control
  final AudioPlayer audioPlayer = AudioPlayer(); // For voice narration
  final AudioPlayer backgroundMusicPlayer = AudioPlayer(); // For background music
  final RxBool isPlaying = false.obs;
  final RxBool isRecording = false.obs;
  final RxString currentNarrator = ''.obs;
  final RxDouble recordingProgress = 0.0.obs;
  final RxString recordingTime = "00:00".obs;

  // Background music control
  final RxBool isMusicPlaying = true.obs;
  final RxDouble musicVolume = 0.3.obs; // Default volume for background music

  // UI control
  final RxBool showThumbnails = false.obs;

  // Book metadata for credits
  final String authorName = "ALTAI ZEINALOV";
  final String illustratorName = "ANNA GORLACH";
  final String composerName = "ARTEM AKMULIN";

  // Sample pages for the book
  final List<BookPage> pages = [
    BookPage(
      content: "In an ordinary town, in an ordinary family...",
      imageUrl: "assets/images/gambar1.png",
    ),
    BookPage(
      content: "There lived a boy named Tim with his parents and his cat Whiskers.",
      imageUrl: "assets/images/gambar2.png",
    ),
    BookPage(
      content: "Whiskers was an extraordinary cat with bright orange fur.",
      imageUrl: "assets/images/gambar3.png",
    ),
    BookPage(
      content: "Every night, Whiskers would curl up on Tim's bed, purring softly.",
      imageUrl: "assets/images/gambar4.png",
    ),
    BookPage(
      content: "One evening, as Tim was getting ready for bed, his parents came to tuck him in.",
      imageUrl: "assets/images/gambar1.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "Whiskers jumped onto the bed with a toy mouse in his mouth.",
      imageUrl: "assets/images/gambar2.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "Tim giggled as Whiskers chased the toy around the room.",
      imageUrl: "assets/images/gambar3.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "His parents smiled, kissed Tim goodnight, and turned off the lights.",
      imageUrl: "assets/images/gambar4.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "But Whiskers wasn't ready to sleep yet. He had a special talent.",
      imageUrl: "assets/images/gambar1.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "As the moonlight filtered through the window, something magical began to happen.",
      imageUrl: "assets/images/gambar2.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "Whiskers started to glow with a soft blue light, his eyes twinkling like stars.",
      imageUrl: "assets/images/gambar3.png", // Repeated for demo purposes
    ),
    BookPage(
      content: "And that night, Whiskers took Tim on an adventure beyond his wildest dreams...",
      imageUrl: "assets/images/gambar4.png", // Repeated for demo purposes
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController
    pageController = PageController();

    // Start background music
    _initBackgroundMusic();

    // Set up audio player listeners
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;

      // Auto-advance to next page when audio finishes
      if (state == PlayerState.completed && currentPage.value < pages.length - 1) {
        nextPage();
      }
    });

    // Recording timer simulation (for demo purposes)
    ever(isRecording, (recording) {
      if (recording) {
        _startRecordingTimer();
      }
    });

    // Listen for music volume changes
    ever(musicVolume, (volume) {
      backgroundMusicPlayer.setVolume(volume);
    });

    // Listen for music playing state changes
    ever(isMusicPlaying, (playing) {
      if (playing) {
        backgroundMusicPlayer.resume();
      } else {
        backgroundMusicPlayer.pause();
      }
    });
  }

  void _initBackgroundMusic() async {
    // In a real app, you would use an actual audio file
    // await backgroundMusicPlayer.setSourceUrl('assets/audio/background_music.mp3');
    // For now, let's just set the playing state
    isMusicPlaying.value = true;

    // Set initial volume
    backgroundMusicPlayer.setVolume(musicVolume.value);
  }

  @override
  void onClose() {
    // Critical fix: properly dispose of the PageController
    pageController.dispose();
    audioPlayer.dispose();
    backgroundMusicPlayer.dispose();
    super.onClose();
  }

  void updatePage(int page) {
    if (page >= 0 && page < pages.length) {
      currentPage.value = page;

      // If in listening mode, play the current page's audio
      if (isPlaying.value) {
        // Play audio for the current page (demo implementation)
        // In a real app, you would use actual audio files
        // audioPlayer.play(AssetSource(pages[page].audioUrl ?? ''));

        // For demo purposes, we'll just print that we're playing
        print('Playing audio for page ${page + 1}');
      }
    }
  }

  void nextPage() {
    print('nextPage called. Current page: ${currentPage.value}, Total pages: ${pages.length}');

    if (currentPage.value < pages.length - 1) {
      // Move to next page
      int nextPageIndex = currentPage.value + 1;
      currentPage.value = nextPageIndex;

      // Animate to that page
      pageController.animateToPage(
        nextPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // We're at the last page, show ending
      print('Showing ending overlay');
      _showEndingOverlay();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      int prevPageIndex = currentPage.value - 1;
      currentPage.value = prevPageIndex;

      pageController.animateToPage(
        prevPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showEndingOverlay() {
    // Dim background music
    double originalVolume = musicVolume.value;
    musicVolume.value = originalVolume * 0.5;

    // Show the ending overlay
    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: BookEndingOverlay(
          authorName: authorName,
          illustratorName: illustratorName,
          composerName: composerName,
          onRestartBook: restartBook,
        ),
      ),
      barrierDismissible: false,
    ).then((_) {
      // Restore music volume when dialog is closed
      musicVolume.value = originalVolume;
    });
  }

  void restartBook() {
    // Reset to the first page
    currentPage.value = 0;
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer.pause();
      isPlaying.value = false;
    } else {
      // In a real app, you would play the audio file for the current page
      // audioPlayer.play(AssetSource(pages[currentPage.value].audioUrl ?? ''));

      // For demo purposes:
      isPlaying.value = true;
      Future.delayed(const Duration(seconds: 5), () {
        // Auto-stop after 5 seconds for demo purposes
        if (isPlaying.value) {
          isPlaying.value = false;
        }
      });
    }
  }

  void toggleBackgroundMusic() {
    isMusicPlaying.value = !isMusicPlaying.value;
  }

  void setMusicVolume(double volume) {
    if (volume >= 0.0 && volume <= 1.0) {
      musicVolume.value = volume;
    }
  }

  void toggleThumbnails() {
    showThumbnails.value = !showThumbnails.value;
  }

  void startRecording(String narratorName) {
    currentNarrator.value = narratorName;
    isRecording.value = true;
    recordingProgress.value = 0.0;
    recordingTime.value = "00:00";
  }

  void stopRecording() {
    isRecording.value = false;
    // In a real app, you would save the recording
  }

  void _startRecordingTimer() {
    // Simulated recording timer for demo purposes
    if (isRecording.value) {
      int seconds = 0;
      recordingTime.value = "00:00";

      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!isRecording.value) return false;

        seconds++;
        int minutes = seconds ~/ 60;
        int remainingSeconds = seconds % 60;
        recordingTime.value = "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
        recordingProgress.value = (seconds % 60) / 60; // Cycle every minute

        return isRecording.value;
      });
    }
  }

  int get totalPages => pages.length;
}