
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:authenticationapp/screens/home_screeen.dart';
import 'package:authenticationapp/screens/intropage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data!.emailVerified) {
          return HomeScreen();
        }

        return ToDoListIntro();
      },
    );
  }
}