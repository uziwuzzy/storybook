// import "package:get/get.dart";
// import "package:flutter/material.dart";
// import "package:audioplayers/audioplayers.dart";
// import "package:storybook/models/book_reader.dart";
// import "package:storybook/widgets/book_ending/book_ending_overlay.dart";
//
// class BookReaderController extends GetxController {
//   // Page control
//   final RxInt currentPage = 0.obs;
//   final RxBool showEndingOverlay = false.obs;
//
//   // Audio control
//   final AudioPlayer audioPlayer = AudioPlayer(); // For voice narration
//   final AudioPlayer backgroundMusicPlayer = AudioPlayer(); // For background music
//   final RxBool isPlaying = false.obs;
//   final RxBool isRecording = false.obs;
//   final RxString currentNarrator = ''.obs;
//   final RxDouble recordingProgress = 0.0.obs;
//   final RxString recordingTime = "00:00".obs;
//
//   // Background music control
//   final RxBool isMusicPlaying = true.obs;
//   final RxDouble musicVolume = 0.3.obs; // Default volume for background music
//
//   // UI control
//   final RxBool showThumbnails = false.obs;
//
//   // Book metadata for credits
//   final String authorName = "ALTAI ZEINALOV";
//   final String illustratorName = "ANNA GORLACH";
//   final String composerName = "ARTEM AKMULIN";
//
//   // Sample pages for the book
//   final List<BookPage> pages = [
//     BookPage(
//       content: "One sunny morning, Luna, a curious girl with a big imagination, set off on an adventure. She loved exploring, but today felt different. The wind whispered her name, and the flowers swayed as if inviting her somewhere special.",
//       imageUrl: "assets/images/luna_1.png",
//     ),
//     BookPage(
//       content: """As Luna walked through the golden fields, she saw something incredible—a giant giraffe with deep purple spots, resting like a lazy cloud.
//
// "Where are you going?" the giraffe asked with a smile.
//
// "I'm not sure," Luna said, "but I want to find something magical."
//
// "Hop on," the giraffe said, kneeling down.""",
//       imageUrl: "assets/images/luna_2.png",
//     ),
//     BookPage(
//       content: "Luna climbed onto the giraffe's back, and off they went—running through fields that turned into rivers of stars! The clouds swirled into shapes, and the sun painted golden patterns in the sky.",
//       imageUrl: "assets/images/luna_3.png",
//     ),
//     BookPage(
//       content: """They arrived at a hidden meadow where a gigantic black cat was stretched out like a fluffy mountain. Its big, glowing eyes blinked slowly.
//       "You seek magic?" the cat purred.""",
//       imageUrl: "assets/images/luna_4.png",
//     ),
//     BookPage(
//       content: """The cat flicked its tail, and suddenly, Luna felt lighter—as if she could float!
//       "Magic is everywhere," the cat whispered. "But you must look with wonder.""",
//       imageUrl: "assets/images/luna_5.png", // Repeated for demo purposes
//     ),
//     BookPage(
//       content: """Luna stepped off the giraffe and twirled through the meadow. Tiny golden fireflies danced around her, forming patterns in the air—stars, moons, and swirling galaxies!""",
//       imageUrl: "assets/images/luna_6.png", // Repeated for demo purposes
//     ),
//     BookPage(
//       content: """As she danced, a hidden door appeared in a tree, glowing softly.
//     "What’s inside?" she wondered.
//     "The answer to your heart’s biggest question," the cat said.""",
//       imageUrl: "assets/images/luna_7.png", // Repeated for demo purposes
//     ),
//     BookPage(
//       content: """Inside, Luna saw mirrors reflecting her adventures—the giraffe’s kindness, the cat’s wisdom, and the wonder of the world.
// She gasped. The magic wasn’t a place—it was within her all along!""",
//       imageUrl: "assets/images/luna_8.png", // Repeated for demo purposes
//     ),
//     BookPage(
//       content: """Luna stepped out of the tree, feeling different. She hugged the giraffe’s long neck and scratched behind the cat’s ears.
// "Thank you," she whispered.""",
//       imageUrl: "assets/images/luna_9.png", // Repeated for demo purposes
//     ),
//     BookPage(
//       content: """As she walked home, the world looked brighter—the grass whispered secrets, the wind hummed songs, and the stars blinked just for her.
// She had found what she was looking for: magic was everywhere, as long as she believed.""",
//       imageUrl: "assets/images/luna_10.png", // Repeated for demo purposes
//     )
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Set up audio player listeners
//     audioPlayer.onPlayerStateChanged.listen((state) {
//       isPlaying.value = state == PlayerState.playing;
//
//       // Auto-advance to next page when audio finishes
//       if (state == PlayerState.completed && currentPage.value < pages.length - 1) {
//         nextPage();
//       }
//     });
//
//     // Recording timer simulation (for demo purposes)
//     ever(isRecording, (recording) {
//       if (recording) {
//         _startRecordingTimer();
//       }
//     });
//
//     // Listen for music volume changes
//     ever(musicVolume, (volume) {
//       backgroundMusicPlayer.setVolume(volume);
//     });
//
//     // Listen for music playing state changes
//     ever(isMusicPlaying, (playing) {
//       if (playing) {
//         backgroundMusicPlayer.resume();
//       } else {
//         backgroundMusicPlayer.pause();
//       }
//     });
//
//     // Initialize background music
//     _initBackgroundMusic();
//   }
//
//   void _initBackgroundMusic() async {
//     // In a real app, you would use an actual audio file
//     // await backgroundMusicPlayer.setSourceUrl('assets/audio/background_music.mp3');
//     // For now, let's just set the playing state
//     isMusicPlaying.value = true;
//
//     // Set initial volume
//     backgroundMusicPlayer.setVolume(musicVolume.value);
//   }
//
//   @override
//   void onClose() {
//     audioPlayer.dispose();
//     backgroundMusicPlayer.dispose();
//     super.onClose();
//   }
//
//   void updatePage(int page) {
//     if (page >= 0 && page < pages.length) {
//       currentPage.value = page;
//
//       // If in listening mode, play the current page's audio
//       if (isPlaying.value) {
//         // Play audio for the current page (demo implementation)
//         // In a real app, you would use actual audio files
//         // audioPlayer.play(AssetSource(pages[page].audioUrl ?? ''));
//
//         // For demo purposes, we'll just print that we're playing
//         print('Playing audio for page ${page + 1}');
//       }
//     }
//   }
//
//   void nextPage() {
//     print('nextPage called. Current page: ${currentPage.value}, Total pages: ${pages.length}');
//
//     if (currentPage.value < pages.length - 1) {
//       // Move to next page
//       updatePage(currentPage.value + 1);
//     } else {
//       // We're at the last page, show ending
//       print('Showing ending overlay');
//       displayEndingOverlay();
//     }
//   }
//
//   void previousPage() {
//     if (currentPage.value > 0) {
//       updatePage(currentPage.value - 1);
//     }
//   }
//
//   void displayEndingOverlay() {
//     // Dim background music
//     double originalVolume = musicVolume.value;
//     musicVolume.value = originalVolume * 0.5;
//
//     // Show the ending overlay
//     Get.dialog(
//       BookEndingOverlay(
//         authorName: authorName,
//         illustratorName: illustratorName,
//         composerName: composerName,
//         onRestartBook: restartBook,
//       ),
//       barrierDismissible: false,
//     ).then((_) {
//       // Restore music volume when dialog is closed
//       musicVolume.value = originalVolume;
//     });
//   }
//
//   void restartBook() {
//     // Reset to the first page
//     updatePage(0);
//   }
//
//   void togglePlayPause() {
//     if (isPlaying.value) {
//       audioPlayer.pause();
//       isPlaying.value = false;
//     } else {
//       // In a real app, you would play the audio file for the current page
//       // audioPlayer.play(AssetSource(pages[currentPage.value].audioUrl ?? ''));
//
//       // For demo purposes:
//       isPlaying.value = true;
//       Future.delayed(const Duration(seconds: 5), () {
//         // Auto-stop after 5 seconds for demo purposes
//         if (isPlaying.value) {
//           isPlaying.value = false;
//         }
//       });
//     }
//   }
//
//   void toggleBackgroundMusic() {
//     isMusicPlaying.value = !isMusicPlaying.value;
//   }
//
//   void setMusicVolume(double volume) {
//     if (volume >= 0.0 && volume <= 1.0) {
//       musicVolume.value = volume;
//     }
//   }
//
//   void toggleThumbnails() {
//     showThumbnails.value = !showThumbnails.value;
//   }
//
//   void startRecording(String narratorName) {
//     currentNarrator.value = narratorName;
//     isRecording.value = true;
//     recordingProgress.value = 0.0;
//     recordingTime.value = "00:00";
//   }
//
//   void stopRecording() {
//     isRecording.value = false;
//     // In a real app, you would save the recording
//   }
//
//   void _startRecordingTimer() {
//     // Simulated recording timer for demo purposes
//     if (isRecording.value) {
//       int seconds = 0;
//       recordingTime.value = "00:00";
//
//       Future.doWhile(() async {
//         await Future.delayed(const Duration(seconds: 1));
//         if (!isRecording.value) return false;
//
//         seconds++;
//         int minutes = seconds ~/ 60;
//         int remainingSeconds = seconds % 60;
//         recordingTime.value = "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
//         recordingProgress.value = (seconds % 60) / 60; // Cycle every minute
//
//         return isRecording.value;
//       });
//     }
//   }
//
//   int get totalPages => pages.length;
// }

import "package:get/get.dart";
import "package:flutter/material.dart";
import "package:audioplayers/audioplayers.dart";
import "package:storybook/models/book_reader.dart";
import "package:storybook/widgets/book_ending/book_ending_overlay.dart";

class BookReaderController extends GetxController {
  // Page control
  final RxInt currentPage = 0.obs;
  final RxBool showEndingOverlay = false.obs;

  // Audio control
  final AudioPlayer audioPlayer = AudioPlayer(); // For voice narration
  final AudioPlayer backgroundMusicPlayer = AudioPlayer(); // For background music
  final RxBool isPlaying = false.obs;
  final RxBool isRecording = false.obs;
  final RxString currentNarrator = "".obs;
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
      content: "One sunny morning, Luna, a curious girl with a big imagination, set off on an adventure. She loved exploring, but today felt different. The wind whispered her name, and the flowers swayed as if inviting her somewhere special.",
      imageUrl: "assets/images/luna_1.png",
    ),
    BookPage(
      content: """As Luna walked through the golden fields, she saw something incredible—a giant giraffe with deep purple spots, resting like a lazy cloud.

"Where are you going?" the giraffe asked with a smile.

"I'm not sure," Luna said, "but I want to find something magical."

"Hop on," the giraffe said, kneeling down.""",
      imageUrl: "assets/images/luna_2.png",
    ),
    BookPage(
      content: "Luna climbed onto the giraffe's back, and off they went—running through fields that turned into rivers of stars! The clouds swirled into shapes, and the sun painted golden patterns in the sky.",
      imageUrl: "assets/images/luna_3.png",
    ),
    BookPage(
      content: """They arrived at a hidden meadow where a gigantic black cat was stretched out like a fluffy mountain. Its big, glowing eyes blinked slowly.
      "You seek magic?" the cat purred.""",
      imageUrl: "assets/images/luna_4.png",
    ),
    BookPage(
      content: """The cat flicked its tail, and suddenly, Luna felt lighter—as if she could float!
      "Magic is everywhere," the cat whispered. "But you must look with wonder.""",
      imageUrl: "assets/images/luna_5.png", // Repeated for demo purposes
    ),
    BookPage(
      content: """Luna stepped off the giraffe and twirled through the meadow. Tiny golden fireflies danced around her, forming patterns in the air—stars, moons, and swirling galaxies!""",
      imageUrl: "assets/images/luna_6.png", // Repeated for demo purposes
    ),
    BookPage(
      content: """As she danced, a hidden door appeared in a tree, glowing softly.
    "What’s inside?" she wondered.
    "The answer to your heart’s biggest question," the cat said.""",
      imageUrl: "assets/images/luna_7.png", // Repeated for demo purposes
    ),
    BookPage(
      content: """Inside, Luna saw mirrors reflecting her adventures—the giraffe’s kindness, the cat’s wisdom, and the wonder of the world.
She gasped. The magic wasn’t a place—it was within her all along!""",
      imageUrl: "assets/images/luna_8.png", // Repeated for demo purposes
    ),
    BookPage(
      content: """Luna stepped out of the tree, feeling different. She hugged the giraffe’s long neck and scratched behind the cat’s ears.
"Thank you," she whispered.""",
      imageUrl: "assets/images/luna_9.png", // Repeated for demo purposes
    ),
    BookPage(
      content: """As she walked home, the world looked brighter—the grass whispered secrets, the wind hummed songs, and the stars blinked just for her.
She had found what she was looking for: magic was everywhere, as long as she believed.""",
      imageUrl: "assets/images/luna_10.png", // Repeated for demo purposes
    )
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

    // Listen for music volume changes
    ever(musicVolume, (volume) {
      try {
        if (isMusicPlaying.value) {
          backgroundMusicPlayer.setVolume(volume);
        }
      } catch (e) {
        print("Error setting volume: $e");
      }
    });

    // Listen for music playing state changes
    ever(isMusicPlaying, (playing) {
      if (playing) {
        try {
          backgroundMusicPlayer.resume();
        } catch (e) {
          print("Error resuming music: $e");
        }
      } else {
        try {
          backgroundMusicPlayer.pause();
        } catch (e) {
          print("Error pausing music: $e");
        }
      }
    });

    // Initialize background music
    _initBackgroundMusic();
  }

  void _initBackgroundMusic() async {
    try {
      // Set initial state without actually playing
      isMusicPlaying.value = true;
      musicVolume.value = 0.3;
    } catch (e) {
      print("Error initializing background music: $e");
    }
  }

  @override
  void onClose() {
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
        // audioPlayer.play(AssetSource(pages[page].audioUrl ?? ""));

        // For demo purposes, we'll just print that we're playing
        print("Playing audio for page ${page + 1}");
      }
    }
  }

  void nextPage() {
    print("nextPage called. Current page: ${currentPage.value}, Total pages: ${pages.length}");

    if (currentPage.value < pages.length - 1) {
      // Move to next page
      updatePage(currentPage.value + 1);
    } else {
      // We're at the last page, show ending
      print("Showing ending overlay");
      showEndingOverlay();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      updatePage(currentPage.value - 1);
    }
  }

  void displayEndingOverlay() {
    // Store original volume state
    double originalVolume = musicVolume.value;
    bool wasMusicPlaying = isMusicPlaying.value;

    // Dim music if it's playing
    if (wasMusicPlaying) {
      try {
        backgroundMusicPlayer.setVolume(originalVolume * 0.5);
      } catch (e) {
        print("Error adjusting volume: $e");
      }
    }

    // Show the ending overlay with fullscreenDialog to ensure it covers everything
    Get.dialog(
      BookEndingOverlay(
        authorName: authorName,
        illustratorName: illustratorName,
        composerName: composerName,
        onRestartBook: restartBook,
      ),
      barrierDismissible: false,
      useSafeArea: false,  // Important to cover status bar
      barrierColor: Colors.transparent,  // Let the overlay handle its own background
    ).then((_) {
    // Restore music volume if it was playing before
    if (wasMusicPlaying && isMusicPlaying.value) {
    try {
    backgroundMusicPlayer.setVolume(originalVolume);
    } catch (e) {
    print("Error restoring volume: $e");
    }
    }
    });
  }

  void restartBook() {
    // Reset to the first page
    updatePage(0);
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer.pause();
      isPlaying.value = false;
    } else {
      // In a real app, you would play the audio file for the current page
      // audioPlayer.play(AssetSource(pages[currentPage.value].audioUrl ?? ""));

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
        recordingTime.value = "${minutes.toString().padLeft(2, "0")}:${remainingSeconds.toString().padLeft(2, "0")}";
        recordingProgress.value = (seconds % 60) / 60; // Cycle every minute

        return isRecording.value;
      });
    }
  }

  int get totalPages => pages.length;
}