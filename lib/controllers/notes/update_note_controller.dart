import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/models/note_model.dart';
import 'package:note/services/note_service.dart';

class UpdateNoteController extends GetxController {

  final _noteService = NoteService();

  bool isUpdating = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

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

  // variable to store the selected category
  String selectedCategory = '';

  // logic to select a category (to be called when category is selected from UI)
  void selectCategory({
    required String category,
  }) {
    selectedCategory = category;
    update();
  }

  // variable to store if the note is marked as important
  bool isImportant = false;

  // logic to toggle the importance of the note
  void toggleImportance() {
    isImportant = !isImportant;
    update();
  }

  // for user choose categories
  final List<String> categoryOptions = [
    'Work',
    'Personal',
    'Health',
    'Study',
    'Finance',
    'Others',
  ];

  /*
    init form
    pre-fill the text controllers with the current quote data
  */
  void initForm(NoteModel note){
    titleController.text = note.title;
    descriptionController.text = note.description;
    selectedCategory = note.category;
    isImportant = note.isImportant;
    update();
  }

  Future<void> updateNote({
    required String noteId,
  }) async {

    // check if the controller is already in a updating state
    if(isUpdating) return;

    // validate input
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
      isUpdating = true;
      update();

      // update the note in the Database
      await _noteService.updateNote(
        noteId: noteId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        isImportant: isImportant,
      );

      // update the local note in the NoteController
      final noteController = Get.find<NoteController>();
      final updatedNoteIndex = noteController.noteList.indexWhere((note) => note.id == noteId);

      if (updatedNoteIndex != -1) {
        noteController.noteList[updatedNoteIndex] = noteController.noteList[updatedNoteIndex].copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: selectedCategory,
          isImportant: isImportant,
        );
      }

      // update the searched list if applicable
      final searchedNoteIndex = noteController.searchedList.indexWhere((note) => note.id == noteId);
      if (searchedNoteIndex != -1) {
        noteController.searchedList[searchedNoteIndex] = noteController.noteList[updatedNoteIndex];
      }

      // update the controller
      noteController.update();


      // refresh get Important & Normal notes
      Get.put(NoteController()).getAllImportantNotes();
      Get.put(NoteController()).getAllNormalNotes();

      showMessage(
        msg: 'Note updated successfully!',
        txtColor: Colors.white,
        bgColor: Color(0xFF140F2D),
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );

      clearTextField();

      // Close the screen
      Get.back();
      
    } catch (e) {
      showMessage(
        msg: 'Failed to update the note: $e',
        txtColor: Colors.white,
        bgColor: Colors.pink,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    } finally {
      isUpdating = false;
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
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}