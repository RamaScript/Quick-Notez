import 'package:flutter/material.dart';

import '../database/notes_db.dart';
import 'note_card.dart';
import 'notes_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDb.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFD3D3FF), // Lavender
    const Color(0xFFFFABAB), // Light Red
    const Color(0xFF98FB98), // Pale Green
    const Color(0xFFFFE13C), // Gold
    const Color(0xFF7DFFFF), // Pale Turquoise
    const Color(0xFFE4E0E1), // Soft Rose Gray
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int? colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder:
          (dialogcontext) => NotesDialog(
            noteId: id,
            title: title,
            content: content,
            colorIndex: colorIndex!,
            noteColors: noteColors,
            onNoteSaved: (
              newTitle,
              newContent,
              selectedColorIndex,
              currentDate,
            ) async {
              if (id != null) {
                await NotesDb.instance.updateNotes(
                  newTitle,
                  newContent,
                  currentDate,
                  selectedColorIndex,
                  id,
                );
              } else {
                await NotesDb.instance.addNote(
                  newTitle,
                  newContent,
                  currentDate,
                  selectedColorIndex,
                );
              }
              fetchNotes();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quick Notez",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black54),
      ),

      body:
          notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notes_rounded,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 6),
                    Text(
                      "No Notes found \n Click + to Add and Long press to delete",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Padding(
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onDelete: () async {
                        await NotesDb.instance.deleteNotes(note['id']);
                        fetchNotes();
                      },
                      onTap: () {
                        showNoteDialog(
                          id: note['id'],
                          title: note['title'],
                          content: note['description'],
                          colorIndex: note['color'],
                        );
                      },
                      noteColors: noteColors,
                    );
                  },
                ),
              ),
    );
  }
}
