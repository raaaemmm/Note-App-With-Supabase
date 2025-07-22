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
  bool showEmailConfirmationAlert = false;
  String? pendingConfirmationEmail;

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

  // hide email confirmation alert
  void hideEmailConfirmationAlert() {
    showEmailConfirmationAlert = false;
    pendingConfirmationEmail = null;
    update();
  }

  // resend email confirmation
  Future<void> resendEmailConfirmation() async {
    if (pendingConfirmationEmail == null) return;

    try {
      await _authService.resendEmailConfirmation(
        email: pendingConfirmationEmail!,
      );
      
      showMessage(
        msg: 'Confirmation email resent! Please check your inbox.',
        bgColor: Color(0xFF140F2D),
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    } catch (e) {
      String errorMessage = e is String ? e : 'Failed to resend email.';
      showMessage(
        msg: errorMessage,
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    }
  }

  // SIGN-UP
  Future<void> signUp() async {
    
    if(isSignningUp) return;

    try {
      isSignningUp = true;
      update();

      final response = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        displayName: displaynameController.text.trim(),
      );

      // Check if user needs to confirm email
      if (response.user != null && response.user!.emailConfirmedAt == null) {
        // User created but email not confirmed
        pendingConfirmationEmail = emailController.text.trim();
        showEmailConfirmationAlert = true;
        
        showMessage(
          msg: 'Account created! Please check your email to confirm.',
          bgColor: Colors.orange,
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );
        
        clearTextField();
      } else if (response.user != null) {
        // User created and email confirmed (instant confirmation)
        showMessage(
          msg: 'Signed up successfully!',
          bgColor: Color(0xFF140F2D),
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );

        // back to Sign-In Screen
        Get.back();
        clearTextField();
      } else {
        // No user returned
        showMessage(
          msg: 'Error, failed to sign up. Please try again.',
          bgColor: Colors.pink,
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );
      }
    } catch (e) {
      // Handle error: Extract the message if it's an AuthException
      String errorMessage = e is String ? e : 'An unknown error occurred.';
      showMessage(
        msg: 'Oops! $errorMessage',
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
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}