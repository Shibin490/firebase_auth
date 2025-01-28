// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:authenticationapp/screens/intropage.dart';
import 'package:authenticationapp/screens/login.dart';
import 'package:authenticationapp/screens/signup.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

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
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ToDoListIntro(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
