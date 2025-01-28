// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:authenticationapp/services/auth.dart';

class ResetPasswordScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      _showSnackbar(context, 'Please enter your email address.');
      return;
    }

    try {
      await _authService.resetPassword(email);
      _showSnackbar(context, 'Password reset email sent to $email');
      Navigator.pop(context); // Close the reset password screen after success
    } catch (e) {
      _showSnackbar(context, e.toString()); // Show error message
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              Color.fromARGB(255, 35, 0, 230),
              Color.fromARGB(255, 5, 19, 124),
              const Color.fromARGB(255, 2, 7, 13),
              Color.fromARGB(255, 5, 19, 124),
              Color.fromRGBO(35, 0, 230, 0.874),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: const Color.fromARGB(255, 32, 41,
                    200), // Change this to the desired color for the Reset Password box
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Enter your email to receive password reset instructions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 193, 195,
                              199), // Change the background color here
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _resetPassword(
                            context, _emailController.text.trim()),
                        icon: Icon(Icons.lock_reset),
                        label: Text('Send Reset Link'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
