import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/services/auth_service.dart';
import 'package:note/views/screens/home.dart';

class SignInController extends GetxController {

  final _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSignningIn = false;
  bool obscureText = true;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // show or hide password
  void showAndHidePassword() {
    obscureText = !obscureText;
    update();
  }

  void clearTextField() {
    emailController.clear();
    passwordController.clear();
    update();
  }

  // SIGN-IN
  Future<void> signIn() async {
    try {
      isSignningIn = true;
      update();

      final user = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (user != null) {
        showMessage(
          msg: 'Hello, ${user.displayName}!',
          bgColor: const Color(0xFF140F2D),
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );

        // go to Home screen
        Get.offAll(
          () => Home(),
          transition: Transition.rightToLeftWithFade,
        );
        clearTextField();

      } else {
        showMessage(
          msg: 'Invalid email or password. Please try again.',
          bgColor: Colors.pink,
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );
      }
    } catch (e) {
      String errorMessage = e is String ? e : 'Error: An unknown error occurred.';
      showMessage(
        msg: 'Oops! $errorMessage!',
        bgColor: Colors.pink,
          txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    } finally {
      isSignningIn = false;
      update();
    }
  }

  void showMessage({
    required String msg,
    required double fontSize,
    required FontWeight fontWeight,
    required Color bgColor,
    required Color txtColor,
  }) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: GoogleFonts.kantumruyPro(
          color: txtColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
