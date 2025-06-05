import 'package:flutter/material.dart';
import '../database/notes_db.dart';

class NotesViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> get notes => _notes;

  final List<Color> noteColors = [
    const Color(0xFFE4E0E1), // Soft Rose Gray
    const Color(0xFFD3D3FF), // Lavender
    const Color(0xFFFFC2C2), // Light Red
    const Color(0xFF91EF91), // Pale Green
    const Color(0xFFFFE13C), // Gold
    const Color(0xFF9CECEC), // Pale Turquoise
  ];

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDb.instance.getNotes();
    _notes = fetchedNotes;
    notifyListeners();
  }

  Future<void> addNote(String title, String content, String date, int color) async {
    await NotesDb.instance.addNote(title, content, date, color);
    await fetchNotes();
  }

  Future<void> updateNote(String title, String content, String date, int color, int id) async {
    await NotesDb.instance.updateNotes(title, content, date, color, id);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await NotesDb.instance.deleteNotes(id);
    await fetchNotes();
  }
} 