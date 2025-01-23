import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesListScreen extends StatelessWidget {
  void _deleteNote(String noteId) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  void _updateNote(BuildContext context, String noteId, String title, String content) async {
    final TextEditingController _titleController = TextEditingController(text: title);
    final TextEditingController _contentController = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Note'),
          content: Column(
            children: [
              TextField(controller: _titleController),
              TextField(controller: _contentController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('notes').doc(noteId).update({
                    'title': _titleController.text,
                    'content': _contentController.text,
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print('Error updating note: $e');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes List')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notes found.'));
          }

          final notes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['title']),
                subtitle: Text(note['content']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _updateNote(context, note.id, note['title'], note['content']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNote(note.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
