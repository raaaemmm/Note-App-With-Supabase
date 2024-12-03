import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/controllers/auths/user_controller.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/services/note_service.dart';

class CreateNoteController extends GetxController {

  final _userController = Get.put(UserController());
  final _noteService = NoteService();

  bool isCreating = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // variable to store the selected category
  String selectedCategory = '';

  // for user choose categories
  final List<String> categoryOptions = [
    'Work',
    'Personal',
    'Health',
    'Study',
    'Finance',
    'Others',
  ];

  // variable to store if the note is marked as important
  bool isImportant = false;

  Future<void> createNote() async {

    // check if the controller is already in a creating state
    if (isCreating) return;

    // validate inputs
    if (
      selectedCategory.isEmpty || titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty
    ) {
      showMessage(
        msg: 'Oops! 🤭  You missed some fields, Please check Title Description or Category again!',
        txtColor: Colors.white,
        bgColor: Colors.pink,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      return;
    }

    try {
      isCreating = true;
      update();

      await _noteService.createNote(
        noteId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _userController.currentUser!.uid.toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createDate: DateTime.now().toIso8601String(),
        updateDate: DateTime.now().toIso8601String(),
        category: selectedCategory,
        isImportant: isImportant,
      );
      showMessage(
        msg: 'Note created successfully!',
        txtColor: Colors.white,
        bgColor: Color(0xFF140F2D),
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );

      // refresh the Notes data
      Get.put(NoteController()).getAllNotes();
      Get.put(NoteController()).getAllImportantNotes();
      Get.put(NoteController()).getAllNormalNotes();

      clearTextField();

      // Close the screen after creating the note
      Get.back();
    } catch (e) {
      showMessage(
        msg: 'Oops! Cannot create note: $e',
        txtColor: Colors.white,
        bgColor: Colors.pink,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Error creating note: $e');
    } finally {
      isCreating = false;
      update();
    }
  }

  // logic to select a category (to be called when category is selected from UI)
  void selectCategory({
    required String category,
  }) {
    selectedCategory = category;
    update();
  }

  // logic to toggle the importance of the note
  void toggleImportance() {
    isImportant = !isImportant;
    update();
  }

  void clearTextField(){
    titleController.clear();
    descriptionController.clear();
    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
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
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
