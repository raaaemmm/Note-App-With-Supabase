import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/models/user_model.dart';
import 'package:note/services/auth_service.dart';
import 'package:note/views/auths/sign_in_screen.dart';

class UserController extends GetxController {
  
  final _authService = AuthService();
  
  bool isSignningOut = false;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // initialize the controller and fetch the current user
  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
    
    // listen for changes in the authentication state
    _authService.authStateChanges().listen((user) {
      if (user != null) {
        // if user is signed in, fetch current user details
        _currentUser = UserModel.fromSupabaseUser(user);

        // refresh Note Data Real-Time when user Signed
        Get.put(NoteController()).getAllNotes();
        Get.put(NoteController()).getAllNormalNotes();
        Get.put(NoteController()).getAllImportantNotes();
      } else {
        // if user is signed out, reset the current user
        _currentUser = null;
      }
      update();
    });
  }

  // fetch current user data
  void fetchCurrentUser() {
    _currentUser = _authService.getCurrentUserModel();
    update();
  }

  // SIGN-OUT
  Future<void> signOut() async {
    
    if(isSignningOut) return;

    try {
      isSignningOut = true;
      update();

      // perform Sign Out logic
      await _authService.signOut();

      // Go to the Sign-In screen
      Get.offAll(() => SignInScreen());
      _currentUser = null;

      showMessage(
        msg: 'Signed Out successfully!',
        bgColor: Color(0xFF140F2D),
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      
      update();
    } catch (e) {
      showMessage(
        msg: 'Error, An error occurred: $e',
        bgColor: Colors.white,
        txtColor: Colors.pink,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Error, An error occurred: 👉 $e');
    } finally {
      isSignningOut = false;
      update();
    }
  }

  // convert createdAt to a formatted string
  String formatDate({
    required String createdAt,
  }) {
    try {
      final dateTime = DateTime.tryParse(createdAt);
      if (dateTime != null) {
        // Format the date as "Friday, 29 November 2024 | 3:40 PM"
        final formattedDate = DateFormat('EEEE, d-MMMM-yyyy').format(dateTime);
        return formattedDate;
      }
      return createdAt;
    } catch (e) {
      debugPrint('Error formatting createdAt: $e');
      return 'N/A';
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