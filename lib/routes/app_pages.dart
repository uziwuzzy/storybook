import 'package:get/get.dart';
import 'package:storybook/binding/home_binding.dart';
import 'package:storybook/binding/book_binding.dart';
import 'package:storybook/views/home/home_screen.dart';
import 'package:storybook/views/book_intro/book_intro_screen.dart';
import 'package:storybook/views/book_reader/book_reader_screen.dart';
import 'package:storybook/views/auth/login_screen.dart';
import 'package:storybook/views/auth/forgot_password_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.BOOK_INTRO,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>?;
        return BookIntroScreen(
          bookTitle: arguments?['bookTitle'] ?? 'Story Book',
          bookCoverUrl: arguments?['bookCoverUrl'] ?? 'assets/images/gambar1.png',
        );
      },
      binding: BookBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOK_READER,
      page: () => BookReaderScreen(),
      binding: BookBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
    ),
  ];
}