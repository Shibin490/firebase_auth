import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add note to Firestore
  Future<void> _addNote() async {
    if (_noteController.text.isNotEmpty) {
      try {
        await _firestore.collection('notes').add({
          'note': _noteController.text,
          'createdAt': Timestamp.now(), // Store the creation time
        });
        _noteController.clear();
        print("Note added successfully");
      } catch (e) {
        print("Error adding note: $e");
      }
    } else {
      print("Please enter a note");
    }
  }

  // Method to retrieve notes from Firestore
  Stream<QuerySnapshot> _getNotes() {
    return _firestore
        .collection('notes')
        .orderBy('createdAt', descending: true) // Order by creation time
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Enter your note'),
            ),
            ElevatedButton(
              onPressed: _addNote,
              child: Text("Add Note"),
            ),
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
                      return ListTile(
                        title: Text(note['note']),
                        subtitle: Text(note['createdAt'].toDate().toString()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}