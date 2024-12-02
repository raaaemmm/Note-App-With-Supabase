import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/services/auth_service.dart';

class ResetPasswordController extends GetxController {

  final _authService = AuthService();
  
  bool isResetingPW = false;
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void clearTextField (){
    emailController.clear();
    update();
  }

  bool showAndHideClearButton(){
    return emailController.text.trim().isNotEmpty;
  }

  // reset Password
  Future<void> resetPassword() async {
    try {
      isResetingPW = true;
      update();

      await _authService.resetPassword(email: emailController.text.trim());
      showMessage(
        msg: 'Password reset link sent to ${emailController.text.trim()}!',
        bgColor: Color(0xFF140F2D),
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );

      clearTextField();
    } catch (e) {
      showMessage(
        msg: 'Error: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Error resetting password: 👉 $e');
    } finally {
      isResetingPW = false;
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