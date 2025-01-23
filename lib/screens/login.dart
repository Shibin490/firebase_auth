// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;

  // Method for logging in with email and password
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/notes-list');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  // Method for signing in with Google
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // If user cancels, stop the loading
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/notes-list');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  // Error dialog method
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 26, 5, 146),
              const Color.fromARGB(255, 2, 7, 13),
              const Color.fromARGB(255, 5, 19, 124),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Email input field
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment:
                        Alignment.centerLeft, // Align the text to the left
                    child: Text(
                      "Welcome back !",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 100),
                    alignment:
                        Alignment.centerLeft, // Align the text to the left
                    child: Text(
                      "login to your account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  // Password input field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  SizedBox(height: 24),

                  // Show loading indicator or login button
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30.0),
                            backgroundColor:
                                const Color.fromARGB(255, 49, 25, 167),
                            textStyle: GoogleFonts.poppins(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "or continue with google",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Google Sign-In button
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signInWithGoogle,
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 36.0),
                            backgroundColor:
                                const Color.fromARGB(255, 49, 25, 167),
                            textStyle: GoogleFonts.poppins(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                  // Inside your LoginScreen widget build method, add the following code below your existing widgets

                  Container(
                    margin: EdgeInsets.only(
                        top: 20), // Optional: margin for spacing
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the row
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the SignUp page
                            Navigator.pushReplacementNamed(context, '/sign-up');
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors
                                  .blueAccent, // Highlight color for the text
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
