import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/services/auth_service.dart';

class SignUpController extends GetxController {
  
  final _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displaynameController = TextEditingController();

  bool isSignningUp = false;
  bool obscureText = true;

  @override
  void onClose() {
    displaynameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // show or hide password
  void showAndHidePassword() {
    obscureText = !obscureText;
    update();
  }

  void clearTextField(){
    displaynameController.clear();
    emailController.clear();
    passwordController.clear();
    update();
  }

  // SIGN-UP
  Future<void> signUp() async {
    
    if(isSignningUp) return;

    try {
      isSignningUp = true;
      update();

      final user = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        displayName: displaynameController.text.trim(),
      );

      if (user != null) {
        showMessage(
          msg: 'Signed up successfully!',
          bgColor: Colors.white,
          txtColor: Color(0xFF140F2D),
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );

        // back to Sign-In Screen
        Get.back();
        clearTextField();
      } else {
        // display a general error message if no user is returned
        showMessage(
          msg: 'Error, failed to sign up. Please try again.',
          bgColor: Colors.pink,
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );
      }
    } catch (e) {
      // handle error: Extract the message if it's an AuthException
      String errorMessage = e is String ? e : 'Error: An unknown error occurred.';
      showMessage(
        msg: 'Oops! $errorMessage!',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    } finally {
      isSignningUp = false;
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