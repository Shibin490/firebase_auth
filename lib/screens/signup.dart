// ignore_for_file: prefer_const_constructors

import 'package:authenticationapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await _authService.signUpWithEmail(email, password);

    if (user != null) {
      _showSnackbar('Sign up successful! Verification email sent.');
    } else {
      _showSnackbar('Sign up failed. Please try again.');
    }
  }

  void _signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();

    if (user != null) {
      _showSnackbar('Google Sign-In successful.');
    } else {
      _showSnackbar('Google Sign-In failed.');
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make the Scaffold background transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color.fromARGB(255, 26, 5, 146), // Top color
              Color.fromARGB(255, 2, 7, 13), // Middle color
              Color.fromARGB(255, 5, 19, 124), // Bottom color
            ],
          ),
        ),
        child: Center(
          // Centering the entire content of the body
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Align items vertically in the center
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center items horizontally
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 30), // Space between text and next elements
                    child: Text(
                      'Getting started!!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up with Email'),
                  ),
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: Text('Sign In with Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
