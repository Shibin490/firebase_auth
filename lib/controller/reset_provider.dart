// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:authenticationapp/controller/auth.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();

  String _statusMessage = '';
  String get statusMessage => _statusMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _setStatusMessage('Please enter your email address.');
      return;
    }

    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _setStatusMessage('Password reset email sent to $email');
      Navigator.pop(context);
    } catch (e) {
      _setStatusMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setStatusMessage(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
