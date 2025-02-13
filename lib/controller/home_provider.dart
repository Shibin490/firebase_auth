// ignore_for_file: avoid_print
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream subscription for real-time updates
  StreamSubscription<QuerySnapshot>? _notesSubscription;

  // Method to listen to notes specific to the current user
  void listenToNotes() {
    _notesSubscription?.cancel(); // Cancel existing subscription if any

    User? user = _auth.currentUser; // Get current user
    if (user != null) {
      _notesSubscription = FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: user.uid) // Filter by current user's UID
          // Removed the orderBy to avoid index requirement
          .snapshots()
          .listen(
        (snapshot) {
          // Convert Firestore data to a list of maps
          _notes = snapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    'note': doc['note'],
                    'createdAt': (doc['createdAt'] as Timestamp).toDate(),
                  })
              .toList();

          // Sort the notes manually in descending order of 'createdAt'
          _notes.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

          notifyListeners();
        },
        onError: (error) {
          print('Error listening to notes: $error');
          _error = error.toString();
          notifyListeners();
        },
      );
    }
  }

  // Method to add a note for the current user
  Future<void> addNote(String content) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      User? user = _auth.currentUser; // Get current user
      if (user != null) {
        await FirebaseFirestore.instance.collection('notes').add({
          'note': content,
          'createdAt': DateTime.now(),
          'userId': user.uid, // Store the user's UID
        });
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to add note: $e';
      notifyListeners();
      print('Error adding note: $e');
    }
  }

  // Method to update a note owned by the current user
  Future<void> updateNote(String id, String newContent) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      User? user = _auth.currentUser; // Get current user
      if (user != null) {
        // Ensure you're updating the note of the current user
        DocumentSnapshot noteSnapshot =
            await FirebaseFirestore.instance.collection('notes').doc(id).get();
        if (noteSnapshot.exists && noteSnapshot.get('userId') == user.uid) {
          await FirebaseFirestore.instance.collection('notes').doc(id).update({
            'note': newContent,
            'createdAt': DateTime.now(),
          });
        } else {
          _error = 'You do not have permission to update this note.';
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to update note: $e';
      notifyListeners();
      print('Error updating note: $e');
    }
  }

  // Method to delete a note owned by the current user
  Future<void> deleteNote(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      User? user = _auth.currentUser; // Get current user
      if (user != null) {
        // Ensure you're deleting the note of the current user
        DocumentSnapshot noteSnapshot =
            await FirebaseFirestore.instance.collection('notes').doc(id).get();
        if (noteSnapshot.exists && noteSnapshot.get('userId') == user.uid) {
          await FirebaseFirestore.instance.collection('notes').doc(id).delete();
        } else {
          _error = 'You do not have permission to delete this note.';
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to delete note: $e';
      notifyListeners();
      print('Error deleting note: $e');
    }
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }
}
