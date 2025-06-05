import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/notes_viewmodel.dart';
import 'note_card.dart';
import 'notes_screen_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesViewModel>(context, listen: false).fetchNotes();
  }

  void openNoteScreen({
    int? id,
    String? title,
    String? content,
    int? colorIndex = 0,
    bool isViewOnly = false,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesScreenView(
          noteId: id,
          title: title,
          content: content,
          colorIndex: colorIndex!,
          noteColors: Provider.of<NotesViewModel>(context, listen: false).noteColors,
          onNoteSaved: (
            newTitle,
            newContent,
            selectedColorIndex,
            currentDate,
          ) async {
            if (id != null) {
              await Provider.of<NotesViewModel>(context, listen: false).updateNote(
                newTitle,
                newContent,
                currentDate,
                selectedColorIndex,
                id,
              );
            } else {
              await Provider.of<NotesViewModel>(context, listen: false).addNote(
                newTitle,
                newContent,
                currentDate,
                selectedColorIndex,
              );
            }
          },
        ),
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
          openNoteScreen();
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black54),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, child) {
          final notes = viewModel.notes;
          return notes.isEmpty
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
                          await viewModel.deleteNote(note['id']);
                        },
                        onTap: () {
                          openNoteScreen(
                            id: note['id'],
                            title: note['title'],
                            content: note['description'],
                            colorIndex: note['color'],
                            isViewOnly: true,
                          );
                        },
                        noteColors: viewModel.noteColors,
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
