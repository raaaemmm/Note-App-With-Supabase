import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/services/auth_service.dart';
import 'package:note/views/auths/new_password_screen.dart';

class NewPasswordController extends GetxController {

  final _authService = AuthService();
  
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  bool isHandlingPasswordReset = false;
  bool obscureText = true;
  bool obscureTextConfirmPassword = true;

  // used for Deep Link concept
  var appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    _listenForDeepLinks();
  }

  void clearTextFields() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    update();
  }

  // show or hide password
  void showAndHidePassword() {
    obscureText = !obscureText;
    update();
  }

  // show or hide confirm password
  void showAndHideConfirmPassword() {
    obscureTextConfirmPassword = !obscureTextConfirmPassword;
    update();
  }

  bool canSavePassword() {
    return newPasswordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty &&
        newPasswordController.text.trim() == confirmPasswordController.text.trim();
  }

  void _listenForDeepLinks() async {
    try {
      final Uri? initialLink = await appLinks.getInitialLink();
      if (initialLink != null) {
        // only handle initial deep link if the app is at the home route (or some specific route)
        if (Get.currentRoute == '/') {
          _handleUri(initialLink);
          debugPrint("Initial deep link detected: 👉 $initialLink");
        } else {
          debugPrint("Skipping initial deep link as the app is already on another route.");
        }
      }

      // listen for subsequent deep links and handle them
      appLinks.uriLinkStream.listen((uri) {
        if (_isValidDeepLink(uri)) {
          _handleUri(uri);
          debugPrint("Deep link received: 👉 $uri");
        } else {
          debugPrint("Invalid or duplicate deep link ignored: 👉 $uri");
        }
      });
    } catch (e) {
      debugPrint("Error handling deep link: $e");
    }
  }

  void _handleUri(Uri uri) {
    if (uri.scheme == 'supabase.noteapp' && uri.host == 'reset-password') {
      final code = uri.queryParameters['code'];
      if (code != null) {
        final currentRoute = Get.currentRoute;
        // navigate to NewPasswordScreen if not already there
        if (currentRoute != '/NewPasswordScreen') {
          Get.offAll(
            () => NewPasswordScreen(code: code),
            transition: Transition.rightToLeftWithFade,
            predicate: (route) => false, // ensures no navigation stack is retained
          );
          debugPrint("Navigating to NewPasswordScreen with code: 👉 $code");
        }
      } else {
        showMessage(
          msg: 'Invalid or expired reset link.',
          bgColor: Colors.pink,
          txtColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        );
        debugPrint("Invalid or missing reset code in URI.");
      }
    }
  }

  // helper method to validate the deep link
  bool _isValidDeepLink(Uri uri) {
    // add your validation logic here, for example, check that the link is not a duplicate
    return uri.scheme == 'supabase.noteapp' && uri.host == 'reset-password';
  }

  // handle Password Reset via Deep Link
  Future<void> handlePasswordReset() async {
    if (isHandlingPasswordReset) return;

    // validate confirm password
    if (!canSavePassword()) {
      showMessage(
        msg: 'Oops, 🤭 passwords do not match or are empty!',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      return;
    }

    try {
      isHandlingPasswordReset = true;
      update();

      await _authService.handlePasswordReset(
        newPassword: newPasswordController.text.trim(),
      );

      showMessage(
        msg: 'Password successfully reset!',
        bgColor: const Color(0xFF140F2D),
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );

      // clear text
      clearTextFields();

    } catch (e) {
      debugPrint("Error during password reset: 👉 $e");
      showMessage(
        msg: 'Oops, $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    } finally {
      debugPrint("Password reset process completed.");
      isHandlingPasswordReset = false;
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
