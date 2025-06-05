import 'package:flutter/material.dart';
import 'package:quick_notez/screens/notes_screen.dart';

void main(){
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quick Notez",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: const NotesScreen(),
    );
  }
}

// QuickNotez 