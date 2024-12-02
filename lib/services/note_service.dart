import 'package:flutter/material.dart';
import 'package:note/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteService {
  
  final _client = Supabase.instance.client;

  // note table name
  final String notesTable = 'notes';

  // create a note
  Future<void> createNote({
    required String noteId,
    required String userId,
    required String title,
    required String description,
    required String createDate,
    required String updateDate,
    required String category,
    required bool isImportant,
  }) async {
    try {
      final response = await _client.from(notesTable).insert({
        'id': noteId,
        'user_id': userId,
        'title': title,
        'description': description,
        'create_date': createDate,
        'update_date': updateDate,
        'category': category,
        'is_important': isImportant,
      }).select();

      if (response.isEmpty) {
        throw Exception('Error: Insert operation returned no data.');
      }

      debugPrint('Inserted note: 👉 ${response.first}');
    } catch (e) {
      debugPrint('Error: 👉 $e');
      rethrow;
    }
  }

  // get all notes for a single user
  Stream<List<NoteModel>> getNotesStream({
    required String userId,
  }) {
    return _client
        .from(notesTable)
        .select()
        .eq('user_id', userId)
        .order('create_date', ascending: false)
        .asStream()
        .map(
      (data) => data.map((noteMap) => NoteModel.fromMap(noteMap)).toList(),
    );
  }

  // get notes by category for a single user
  Stream<List<NoteModel>> getNotesByCategoryStream({
    required String userId,
    required String category,
  }) {
    return _client
        .from(notesTable)
        .select()
        .eq('user_id', userId)
        .eq('category', category)
        .order('create_date', ascending: false)
        .asStream()
        .map(
      (data) {
        return data.map((noteMap) => NoteModel.fromMap(noteMap)).toList();
      },
    );
  }

  // update a note by noteId
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
    required String category,
    required bool isImportant,
  }) async {
    try {
      final response = await _client.from(notesTable).update({
        'title': title,
        'description': description,
        'update_date': DateTime.now().toIso8601String(),
        'category': category,
        'is_important': isImportant,
      }).eq('id', noteId).select();

      if (response.isEmpty) {
        throw Exception('Error: Update operation returned no data.');
      }

      debugPrint('Updated note: 👉 ${response.first}');
    } catch (e) {
      debugPrint('Error: 👉 $e');
      rethrow;
    }
  }

  // delete a note by noteId
  Future<void> deleteNote({
    required String noteId,
  }) async {
    try {
      final response = await _client
          .from(notesTable)
          .delete()
          .eq('id', noteId)
          .select();

      if (response.isEmpty) {
        throw Exception('Error: Delete operation failed.');
      }

      debugPrint('Deleted note ID: 👉 $noteId');
    } catch (e) {
      debugPrint('Error: 👉 $e');
      rethrow;
    }
  }
}