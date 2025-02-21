// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:authenticationapp/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignUpProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController(); // Full Name controller
  bool isPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
  Future<void> signUp(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String fullName = nameController.text.trim(); // Get full name

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      _showSnackbar(context, 'Please fill in all fields.');
      return;
    }

    try {
      isLoading = true;
      notifyListeners();
      User? user = await _authService.signUpWithEmail(email, password);
      if (user != null) {
        _showSnackbar(context,
            'Verification email sent. Please verify your email before logging in.');
        Navigator.pushReplacementNamed(context, '/verification');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _showSnackbar(context, e.toString());
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        _showSnackbar(context, 'Google Sign-In successful.');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _showSnackbar(context, e.toString());
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
