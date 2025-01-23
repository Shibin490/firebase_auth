// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:authenticationapp/firestore.dart';
import 'package:authenticationapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Import AddNoteScreen

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp(BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If sign-up is successful, navigate to the AddNoteScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddNoteScreen(),
        ),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void showErrorDialog(BuildContext context, String message) {
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Welcome text

                    Text(
                      "Getting started",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        "create account and continue !",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Email input field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.white, // Change the color of the label
                          fontSize: 18, // Font size of the label
                          // Font weight of the label
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    // Password input field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    // Sign Up button
                    ElevatedButton(
                      onPressed: () => _signUp(context),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: const Color.fromARGB(255, 49, 37, 132),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "or contnue with",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "G",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 20),

                    SizedBox(height: 20),

                    // Sign Up helper text
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen(), // Replace with your LoginScreen
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black), // Default style
                          children: <TextSpan>[
                            TextSpan(
                              text: "Already have an account? ", // Regular text
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 64, 148, 250)), // Regular color
                            ),
                            TextSpan(
                              text: "Log in here", // Text with different color
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold), // Custom color
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
