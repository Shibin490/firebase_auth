import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();
      print('Email verification sent to ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An unknown error occurred: ${e.message}';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
          break;
      }
      // Instead of throwing, return the error message to be shown in the UI
      return Future.error(errorMessage);
    } catch (e) {
      print('Sign-Up Error: $e');
      return Future.error('An unexpected error occurred.');
    }
  }

  // Sign In with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        print('Login successful for ${userCredential.user!.email}');
        return userCredential.user;
      } else {
        print('Email verification required for ${userCredential.user!.email}');
        throw 'Please verify your email before logging in.';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided.';
        default:
          throw 'Login failed: ${e.message}';
      }
    } catch (e) {
      print('Login Error: $e');
      throw 'An unexpected error occurred.';
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign-In was cancelled.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('Google Sign-In successful for ${userCredential.user?.email}');

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        return userCredential.user;
      } else {
        print('Email verification required for ${userCredential.user!.email}');
        throw 'Please verify your email before logging in with Google.';
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      throw 'Google Sign-In failed. Please try again.';
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'invalid-email':
          throw 'The email address is invalid.';
        default:
          throw 'Password reset failed: ${e.message}';
      }
    } catch (e) {
      print('Reset Password Error: $e');
      throw 'An unexpected error occurred.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print('User signed out successfully.');
    } catch (e) {
      print('Sign-Out Error: $e');
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Verify Email and Login
  Future<User?> verifyEmailAndLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        print('Login successful for ${userCredential.user!.email}');
        return userCredential.user;
      } else {
        print('Email verification required for ${userCredential.user!.email}');
        throw 'Please verify your email before logging in.';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided.';
        default:
          throw 'Login failed: ${e.message}';
      }
    } catch (e) {
      print('Login Error: $e');
      throw 'An unexpected error occurred.';
    }
  }
}
