import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note/controllers/auths/user_controller.dart';
import 'package:note/models/note_model.dart';
import 'package:note/services/note_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteController extends GetxController {
  
  final _userController = Get.put(UserController());
  final _noteService = NoteService();

  // for all notes | important & normal
  List<NoteModel> noteList = [];

  // for all important notes
  List<NoteModel> importantNoteList = [];

  // for all normal notes
  List<NoteModel> normalNoteList = [];

  final searchController = TextEditingController();
  List<NoteModel> searchedList = [];
  List<String> searchedHistoryList = [];
  Timer? debounce;

  bool isGettingNotes = false;
  bool isDeletingNote = false;
  bool isGettingImportantNote = false;
  bool isGettingNormalNote = false;

  @override
  void onInit() {
    super.onInit();
    getAllNotes();
    getAllImportantNotes();
    getAllNormalNotes();
    loadSearchNoteHistory();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  final List<String> noteCategories = [
    'All',
    'Work',
    'Personal',
    'Health',
    'Study',
    'Finance',
    'Others',
  ];

  int defaultIndex = 0;

  // for user select note category to show on the screen
  void selecteCategory(int index) {
    defaultIndex = index;
    noteList.clear();

    if (index == 0) {
      getAllNotes();
    } else {
      getAllNotesByCategory(category: noteCategories[index]);
    }
    update();
  }

  bool showAndHideClearButton(){
    return searchController.text.trim().isNotEmpty;
  }

  void clearText() {
    searchController.clear();
    searchedList.clear();
    update();
  }

  // method to handle real-time updates
  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(
      const Duration(milliseconds: 1500), // delay time for user experience
      () {
        if (searchController.text.trim().isNotEmpty) {
          searchNotes(query: query);
          saveSearchNoteKeyword(keyword: query.trim());
        }
      },
    );
    update();
  }

  // method to handle search submission
  void onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      searchNotes(query: query);
      saveSearchNoteKeyword(keyword: query.trim());
    }
    update();
  }

  // save the search keyword
  Future<void> saveSearchNoteKeyword({
    required String keyword,
  }) async {
    try {

      if (!searchedHistoryList.contains(keyword)) {
        searchedHistoryList.insert(0, keyword); // insert at the beginning of the list

        debugPrint('👉 Keyword $keyword added to local!');

        // limit search history to a maximum of 10 items
        if (searchedHistoryList.length > 10) {
          searchedHistoryList.removeLast();
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('searched-note-history', searchedHistoryList);
        update();
      }
    } catch (e) {
      showMessage(
        msg: 'Error saving search note history: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    }
  }

  // load search history
  Future<void> loadSearchNoteHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      searchedHistoryList = prefs.getStringList('searched-note-history') ?? [];
      update();

      debugPrint('Searched note history: 👉 ${searchedHistoryList.length}');
    } catch (e) {
      showMessage(
        msg: 'Error loading search note history: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    }
  }

  // remove a single search keyword
  Future<void> removeSearchNoteKeyword(String keyword) async {
    try {
      searchedHistoryList.remove(keyword);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('searched-note-history', searchedHistoryList);

      debugPrint('Keyword removed!');

      update();
    } catch (e) {
      showMessage(
        msg: 'Error removing search note keyword: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    }
  }

  // remove all search keywords
  Future<void> removeAllSearchNoteKeywords() async {
    try {
      searchedHistoryList.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('searched-note-history');
      update();
    } catch (e) {
      showMessage(
        msg: 'Error removing all search note keyword: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
    }
  }

  // fetch and listen to user-specific notes with real-time updates
  Future<void> getAllNotes() async {
    final userId = _userController.currentUser?.uid;
    try {
      isGettingNotes = true;
      update();

      // subscribe to the note stream
      await for (var updatedNotes in _noteService.getNotesStream(userId: userId!)) {
        noteList = updatedNotes; // set the fetched notes to the noteList
        isGettingNotes = false; // shen data is available, update the UI and stop the loading state
        update();
      }
    } catch (e) {
      showMessage(
        msg: 'Failed to fetch notes: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Failed to fetch notes: 👉 $e');

      isGettingNotes = false;
      update();
    }
  }

  // fetch and listen to notes by category
  Future<void> getAllNotesByCategory({
    required String category,
  }) async {
    final userId = _userController.currentUser?.uid;
    try {
      isGettingNotes = true;
      update();

      // subscribe to the notes by category stream
      await for (var updatedNotes in _noteService.getNotesByCategoryStream(userId: userId!, category: category)) {
        noteList = updatedNotes; // set the fetched notes to the noteList
        isGettingNotes = false; // when data is available, stop the loading state
        update();
      }
    } catch (e) {
      showMessage(
        msg: 'Failed to fetch notes by category: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      isGettingNotes = false; // if fetching fails, stop the loading state
      update();
    }
  }


  // get all important notes
  Future<void> getAllImportantNotes() async {
    final userId = _userController.currentUser?.uid;
    try {
      isGettingImportantNote = true;
      update();

      // subscribe to the note stream
      await for (var updatedNotes in _noteService.getImportantNotesStream(userId: userId!)) {
        importantNoteList = updatedNotes;
        isGettingImportantNote = false;
        update();
      }
    } catch (e) {
      showMessage(
        msg: 'Failed to fetch important notes: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Failed to fetch important notes: 👉 $e');

      isGettingImportantNote = false;
      update();
    }
  }

  // get all normal notes
  Future<void> getAllNormalNotes() async {
    final userId = _userController.currentUser?.uid;
    try {
      isGettingNormalNote = true;
      update();

      // subscribe to the note stream
      await for (var updatedNotes in _noteService.getNormalNotesStream(userId: userId!)) {
        normalNoteList = updatedNotes;
        isGettingNormalNote = false;
        update();
      }
    } catch (e) {
      showMessage(
        msg: 'Failed to fetch normal notes: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Failed to fetch normal notes: 👉 $e');

      isGettingNormalNote = false;
      update();
    }
  }

  // delete note by noteId
  Future<void> deleteNote({
    required String noteId,
  }) async {

    if(isDeletingNote) return;
    
    try {
      isDeletingNote = true;
      update();

      // delete the note from the database
      await _noteService.deleteNote(noteId: noteId);

      // remove the note from the `noteList`
      noteList.removeWhere((note) => note.id == noteId);

      // remove the note from the `importantNoteList`
      importantNoteList.removeWhere((importantNote) => importantNote.id == noteId);

      // remove the note from the `normalNoteList`
      normalNoteList.removeWhere((normalNote) => normalNote.id == noteId);

      // remove the note from the `searchedList`
      searchedList.removeWhere((searchedNote) => searchedNote.id == noteId);

      showMessage(
        msg: 'Note Deleted!',
        bgColor: const Color(0xFF140F2D),
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );

      // update UI
      update();

      // Close the dialog or popup
      Get.back();

    } catch (e) {
      showMessage(
        msg: 'Failed to delete notes: $e',
        bgColor: Colors.pink,
        txtColor: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      );
      debugPrint('Failed to delete notes: 👉 $e');
    } finally {
      isDeletingNote = false;
      update();
    }
  }

  // search notes by title description category & created date
  void searchNotes({
    required String query,
  }){
    searchedList.assignAll(
      noteList.where((note){
          final title = note.title.toLowerCase();
          final description = note.description.toLowerCase();
          final category = note.category.toLowerCase();
          final createdDate = note.createDate.toLocal().toIso8601String().toLowerCase();
          return title.contains(query.toLowerCase()) || description.contains(query.toLowerCase())
          || category.contains(query.toLowerCase()) || createdDate.contains(query.toLowerCase());
        }
      ).toList(),
    );
    update();
  }

  // convert createdAt to a formatted string
  String formatDate({
    required String createdAt,
  }) {
    try {
      final dateTime = DateTime.tryParse(createdAt);
      if (dateTime != null) {
        // format the date as "Friday, 29 November 2024 | 3:40 PM"
        final formattedDate = DateFormat('EEEE, d MMMM yyyy | h:mm a').format(dateTime);
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