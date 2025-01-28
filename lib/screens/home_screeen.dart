// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:authenticationapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final TextEditingController _noteController = TextEditingController();
  String? _editingNoteId;

  HomeScreen({super.key});

  // Method to sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Sign-Out Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  // Method to add or edit a note
  Future<void> _addOrEditNote(BuildContext context) async {
    if (_noteController.text.isNotEmpty) {
      try {
        if (_editingNoteId == null) {
          // Add new note
          await _firestore.collection('notes').add({
            'note': _noteController.text,
            'createdAt': Timestamp.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note added ')),
          );
        } else {
          // Edit existing note
          await _firestore
              .collection('notes')
              .doc(_editingNoteId)
              .update({'note': _noteController.text});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note updated ')),
          );
        }
        _noteController.clear();
        _editingNoteId = null;
        Navigator.of(context).pop(); // Close the dialog after saving
      } catch (e) {
        print("Error adding/editing note: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add/edit note. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a note')),
      );
    }
  }

  // Method to show the dialog for adding or editing a note
  void _showNoteDialog(BuildContext context,
      {String? noteId, String? noteContent}) {
    if (noteId != null && noteContent != null) {
      // Editing an existing note
      _editingNoteId = noteId;
      _noteController.text = noteContent;
    } else {
      // Adding a new note
      _editingNoteId = null;
      _noteController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 58, 12, 207), // Set the background color here
          title: Text(
            _editingNoteId == null ? 'Add Note' : 'Edit Note',
            style: TextStyle(
                color: Colors.white), // Optional: Change title text color
          ),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: 'Enter your note',
              hintStyle: TextStyle(
                  color: Colors.white70,
                  fontWeight:
                      FontWeight.bold), // Optional: Change hint text color
            ),
            autofocus: true,
            maxLines: 3,
            style: TextStyle(
                color:
                    Colors.white), // Optional: Change text color in TextField
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white), // Optional: Change text button color
              ),
            ),
            TextButton(
              onPressed: () => _addOrEditNote(context),
              child: Text(
                _editingNoteId == null ? 'Add' : 'Save',
                style: TextStyle(
                    color: Colors.white), // Optional: Change text button color
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to retrieve notes from Firestore
  Stream<QuerySnapshot> _getNotes() {
    return _firestore
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Method to delete a note
  Future<void> _deleteNote(BuildContext context, String docId) async {
    try {
      await _firestore.collection('notes').doc(docId).delete();
      print("Note deleted successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note deleted successfully')),
      );
    } catch (e) {
      print("Error deleting note: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete note. Please try again.')),
      );
    }
  }

// Method to show a confirmation dialog before deleting a note
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String docId) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color.fromARGB(255, 58, 12, 207), // Dialog background color
          title: Text(
            'Confirm Deletion!',
            style: TextStyle(color: Colors.white), // Title text color
          ),
          content: Text(
            'Are you sure you want to delete this note?',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold), // Content text color
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User clicked 'Cancel'
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white), // Button text color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User clicked 'Delete'
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white), // Button text color
              ),
            ),
          ],
        );
      },
    );

    // If the user confirms, delete the note
    if (confirmDelete == true) {
      await _deleteNote(context, docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 15, 163),
        title: Text(
          "Manage Your Notes",
          style: TextStyle(
              color: const Color.fromARGB(255, 209, 237, 240),
              fontWeight: FontWeight.w800,
              fontSize: 23),
        ),
        actions: [
          Row(
            children: [
              Text(
                'Log Out',
                style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 10,
                    fontWeight: FontWeight.bold // Font size
                    ),
              ),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.logout),
                onPressed: () => _signOut(context),
                tooltip: 'Sign Out',
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 4, 15, 163),
              const Color.fromARGB(255, 4, 15, 163),
              const Color.fromARGB(255, 17, 4, 59),
            ],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final notes = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index].data() as Map<String, dynamic>;
                      DateTime createdAt = note['createdAt'].toDate();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(createdAt);

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: const Color.fromARGB(255, 13, 13, 50),
                        child: ListTile(
                          title: Text(
                            note['note'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            formattedDate,
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _showNoteDialog(
                                  context,
                                  noteId: notes[index].id,
                                  noteContent: note['note'],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _showDeleteConfirmationDialog(
                                    context,
                                    notes[index]
                                        .id), // Show the confirmation dialog before deleting
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showNoteDialog(context),
                  icon: Icon(Icons.add, color: Colors.blue),
                  iconSize: 40, // Optional: adjust the icon size
                  padding: EdgeInsets.all(8), // Optional: adjust padding
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
