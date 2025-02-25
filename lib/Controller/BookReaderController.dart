import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:storybook/Model/BookReader.dart';

class BookReaderController extends GetxController {
  // Page control
  final RxInt currentPage = 0.obs;
  final PageController pageController = PageController();

  // Audio control
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final RxBool isRecording = false.obs;
  final RxString currentNarrator = ''.obs;
  final RxDouble recordingProgress = 0.0.obs;
  final RxString recordingTime = '00:0'.obs;

  // UI control
  final RxBool showThumbnails = false.obs;

  // Sample pages for the book
  final List<BookPage> pages = [
    BookPage(
      content: 'In an ordinary town, in an ordinary family...',
      imageUrl: 'assets/images/gambar1.png',
    ),
    BookPage(
      content: 'There lived a boy named Tim with his parents and his cat Whiskers.',
      imageUrl: 'assets/images/gambar2.png',
    ),
    BookPage(
      content: 'Whiskers was an extraordinary cat with bright orange fur.',
      imageUrl: 'assets/images/page3.png',
    ),
    BookPage(
      content: 'Every night, Whiskers would curl up on Tim\'s bed, purring softly.',
      imageUrl: 'assets/images/page4.png',
    ),
    BookPage(
      content: 'One evening, as Tim was getting ready for bed, his parents came to tuck him in.',
      imageUrl: 'assets/images/page5.png',
    ),
    BookPage(
      content: 'Whiskers jumped onto the bed with a toy mouse in his mouth.',
      imageUrl: 'assets/images/page6.png',
    ),
    BookPage(
      content: 'Tim giggled as Whiskers chased the toy around the room.',
      imageUrl: 'assets/images/page7.png',
    ),
    BookPage(
      content: 'His parents smiled, kissed Tim goodnight, and turned off the lights.',
      imageUrl: 'assets/images/page8.png',
    ),
    BookPage(
      content: 'But Whiskers wasn\'t ready to sleep yet. He had a special talent.',
      imageUrl: 'assets/images/page9.png',
    ),
    BookPage(
      content: 'As the moonlight filtered through the window, something magical began to happen.',
      imageUrl: 'assets/images/page10.png',
    ),
    BookPage(
      content: 'Whiskers started to glow with a soft blue light, his eyes twinkling like stars.',
      imageUrl: 'assets/images/page11.png',
    ),
    BookPage(
      content: 'And that night, Whiskers took Tim on an adventure beyond his wildest dreams...',
      imageUrl: 'assets/images/page12.png',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
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
  }

  @override
  void onClose() {
    pageController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  void updatePage(int page) {
    if (page >= 0 && page < pages.length) {
      currentPage.value = page;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // If in listening mode, play the current page's audio
      if (isPlaying.value) {
        // Play audio for the current page (demo implementation)
        // audioPlayer.play(AssetSource(pages[page].audioUrl ?? ''));

        // For demo purposes, we'll just print that we're playing
        print('Playing audio for page ${page + 1}');
      }
    }
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      updatePage(currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      updatePage(currentPage.value - 1);
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer.pause();
    } else {
      // In a real app, you would play the audio file for the current page
      // audioPlayer.play(AssetSource(pages[currentPage.value].audioUrl ?? ''));

      // For demo purposes:
      isPlaying.value = true;
      Future.delayed(const Duration(seconds: 5), () {
        isPlaying.value = false;
      });
    }
  }

  void toggleThumbnails() {
    showThumbnails.value = !showThumbnails.value;
  }

  void startRecording(String narratorName) {
    currentNarrator.value = narratorName;
    isRecording.value = true;
    recordingProgress.value = 0.0;
    recordingTime.value = '00:0';
  }

  void stopRecording() {
    isRecording.value = false;
    // In a real app, you would save the recording
  }

  void _startRecordingTimer() {
    // Simulated recording timer for demo purposes
    if (isRecording.value) {
      int seconds = 0;
      recordingTime.value = '00:0';

      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!isRecording.value) return false;

        seconds++;
        recordingTime.value = '00:${seconds}';
        recordingProgress.value = (seconds % 60) / 60; // Cycle every minute

        return isRecording.value;
      });
    }
  }

  int get totalPages => pages.length;
}