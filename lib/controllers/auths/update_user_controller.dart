import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note/models/user_model.dart';
import 'package:note/services/auth_service.dart';

class UpdateUserController extends GetxController {
  
  final _authService = AuthService();

  final displayNameController = TextEditingController();
  final shortBioController = TextEditingController();
  final genderController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  bool isUpdatingUser = false;

  @override
  void onClose() {
    displayNameController.dispose();
    shortBioController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }

  void initForm(UserModel user) {
    displayNameController.text = user.displayName ?? '';
    shortBioController.text = user.shortBio ?? '';
    genderController.text = user.gender ?? '';
    dateOfBirthController.text = user.dateOfBirth != null
        ? formatDate(user.dateOfBirth!)
        : ''; // use formatDate to ensure proper format
    update();
  }

  void clearTextField() {
    displayNameController.clear();
    shortBioController.clear();
    genderController.clear();
    dateOfBirthController.clear();
    update();
  }

  Future<void> updateUser() async {
    try {
      isUpdatingUser = true;
      update();

      final dateOfBirth = parseDate(dateOfBirthController.text.trim());

      await _authService.updateUser(
        displayName: displayNameController.text.trim(),
        gender: genderController.text.trim(),
        shortBio: shortBioController.text.trim(),
        dateOfBirth: dateOfBirth,
      );

      showMessage(
        msg: 'User updated successfully!',
        bgColor: const Color(0xFF140F2D),
        txtColor: Colors.white,
      );

      // clear fields
      clearTextField();

      Get.back();
    } catch (e) {
      showMessage(
        msg: 'Error: $e',
        bgColor: Colors.white,
        txtColor: Colors.pink,
      );
      debugPrint('Error: $e');
    } finally {
      isUpdatingUser = false;
      update();
    }
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd-MMMM-yyyy');
    return formatter.format(date);
  }


  DateTime? parseDate(String date) {
    try {
      final formatter = DateFormat('dd-MMMM-yyyy');
      return formatter.parse(date);
    } catch (e) {
      debugPrint('Invalid date format: $e');
      return null;
    }
  }

  void showMessage({
    required String msg,
    Color bgColor = Colors.white,
    Color txtColor = Colors.black,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    int durationSeconds = 2,
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
      duration: Duration(seconds: durationSeconds),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
