// ignore_for_file: library_private_types_in_public_api

import 'package:authenticationapp/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
// Import the AddNoteScreen

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If login is successful, navigate to AddNoteScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddNoteScreen(),
        ),
      );
    } catch (e) {
      showErrorDialog('Login failed: ${e.toString()}');
    }
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      showErrorDialog(e.toString());
      return null;
    }
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      showErrorDialog('Password reset email sent!');
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  Future<void> _sendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        showErrorDialog('Verification email sent!');
      } catch (e) {
        showErrorDialog(e.toString());
      }
    } else {
      showErrorDialog('User already verified or not signed in');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Auth")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: Text("Sign Up"),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text("Reset Password"),
            ),
            ElevatedButton(
              onPressed: _sendVerificationEmail,
              child: Text("Send Verification Email"),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await _signInWithGoogle();
                if (user != null) {
                  print("Signed in as ${user.displayName}");
                  // Navigate to the AddNoteScreen after Google Sign-In
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddNoteScreen()),
                  );
                }
              },
              child: Text("Sign in with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
