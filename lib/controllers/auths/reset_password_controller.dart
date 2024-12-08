import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/controllers/auths/new_password_controller.dart';
import 'package:note/services/auth_service.dart';

class ResetPasswordController extends GetxController {

  final _authService = AuthService();
  final emailController = TextEditingController();

  bool isSendingResetEmail = false;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void clearTextFields() {
    emailController.clear();
    update();
  }

  bool shouldShowClearButton() {
    return emailController.text.trim().isNotEmpty;
  }

  // send Password Reset Email
  Future<void> sendPasswordResetEmail() async {
    if (isSendingResetEmail) return;

    try {
      isSendingResetEmail = true;
      update();

      await _authService.sendPasswordResetEmail(email: emailController.text.trim());

      showMessage(
        msg: 'Password reset link sent to ${emailController.text.trim()}!',
        bgColor: const Color(0xFF140F2D),
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );

      clearTextFields();

      // inite password controller before it running
      Get.put(NewPasswordController());

    } catch (e) {
      showMessage(
        msg: 'Oops, $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Error sending password reset email: 👉 $e');
    } finally {
      isSendingResetEmail = false;
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
