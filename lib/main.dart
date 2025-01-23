import 'package:authenticationapp/listmodel.dart';
import 'package:authenticationapp/screens/headerpage.dart';
import 'package:authenticationapp/screens/signup_screen.dart'; // Import the SignUpScreen
import 'package:authenticationapp/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Import the ToDoListIntro screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ToDoListIntro(), // Set ToDoListIntro as the first screen
      routes: {
        '/signup-screen': (context) => SignUpScreen(), // Route to SignUpScreen
        '/notes-list': (context) => NotesListScreen(), // Route to list notes
        '/add-note': (context) => AddNoteScreen(), // Route to add a note
      },
    );
  }
}
