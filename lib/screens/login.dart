// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:authenticationapp/screens/reset_pass.dart';
import 'package:authenticationapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authenticationapp/screens/home_screeen.dart';
import 'package:authenticationapp/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginLoading = false; // Separate loading state for login
  bool _isGoogleSignInLoading =
      false; // Separate loading state for Google SignIn
  bool _isPasswordVisible = false; // Track the visibility of the password

  // Google Sign-In function
  Future<void> _googleSignIn() async {
    setState(() {
      _isGoogleSignInLoading = true; // Set Google Sign-In loading state to true
    });

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        _showSnackBar(context, 'Google Sign-In successful! Redirecting...');

        // Clear controllers after successful login
        _emailController.clear();
        _passwordController.clear();

        // Navigate to HomeScreen after login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false, // Prevent navigating back to login screen
        );
      } else {
        // User not found
        _showSnackBar(context, 'Google Sign-In failed. Please try again.');
      }
    } catch (e) {
      _showSnackBar(context, 'Error: ${e.toString()}');
    } finally {
      setState(() {
        _isGoogleSignInLoading =
            false; // Set Google Sign-In loading state to false
      });
    }
  }

  // Login function with email & password
  Future<void> _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check if email and password are not empty
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Please fill in both email and password.');
      return;
    }

    setState(() {
      _isLoginLoading = true; // Set login loading state to true
    });

    try {
      final user = await _authService.signInWithEmail(email, password);

      if (user != null) {
        _showSnackBar(context, 'Login successful! Redirecting...');

        // Clear controllers after successful login
        _emailController.clear();
        _passwordController.clear();

        // Navigate to HomeScreen after login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false, // Prevent navigating back to login screen
        );
      } else {
        // User not found
        _showSnackBar(context,
            'User does not exist. Please check your email or sign up.');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      _showSnackBar(context, errorMessage);
    } catch (e) {
      _showSnackBar(context, 'Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoginLoading = false; // Set login loading state to false
      });
    }
  }

  // Show a SnackBar for feedback messages
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 26, 5, 146),
              Color.fromARGB(255, 2, 7, 13),
              Color.fromARGB(255, 5, 19, 124),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login to Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Email TextField
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Password TextField with Visibility Toggle
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordController,
                    obscureText:
                        !_isPasswordVisible, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility state
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors
                                .blue), // Customize the text style if needed
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Loading indicator or Login Button
                  _isLoginLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 16, 22, 203))),
                          onPressed: () => _login(context),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                  SizedBox(height: 20),
                  // Google Sign-In Button
                  _isGoogleSignInLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton.icon(
                          icon: Icon(Icons.login, color: Colors.white),
                          label: Text('Login with Google',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 16, 22, 203),
                          ),
                          onPressed: _googleSignIn,
                        ),
                  SizedBox(height: 20),
                  // Sign up Text
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Don’t have an account? ', // Regular text
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign Up', // Text to be styled differently
                            style: TextStyle(
                              color: Colors.blue, // Set the color of "Sign Up"
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
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
