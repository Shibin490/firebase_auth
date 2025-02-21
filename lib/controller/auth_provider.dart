import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:authenticationapp/controller/auth.dart';

class NotesAuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signUp(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.signUpWithEmail(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.signInWithGoogle();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.signInWithEmail(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.resetPassword(email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.signOut();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthState() async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<void> verifyEmailAndLogin(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.verifyEmailAndLogin(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
