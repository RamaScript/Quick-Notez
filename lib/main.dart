import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/screens/home_screen.dart';
import 'viewmodel/notes_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notez',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: const HomeScreen(),
    );
  }
}

// QuickNotez