// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  VerificationScreen({Key? key}) : super(key: key);

  Future<void> _checkEmailVerification(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await user.reload();
        _checkEmailVerification(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _checkEmailVerification(context));

    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please check your email and verify your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.currentUser?.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Verification email resent!'),
                    duration: Duration(seconds: 2),
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error resending email: $e'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
