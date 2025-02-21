// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:authenticationapp/controller/home_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().listenToNotes();
    });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 6, 6, 74),
            Color.fromARGB(255, 26, 5, 146),
            Color.fromARGB(255, 15, 11, 37),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Notes',
                style: TextStyle(
                  color: Color.fromARGB(255, 203, 208, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const Text(
                'Capture Your Thoughts, Anytime !!',
                style: TextStyle(
                  color: Color.fromARGB(255, 203, 208, 255),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              label: const Text(
                'Images',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              icon: const Icon(Icons.image, color: Colors.blue),
              onPressed: () => Navigator.pushNamed(context, '/s3-home'),
            ),
            TextButton.icon(
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.blue),
              onPressed: () => _handleLogout(context),
            ),
          ],
        ),
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.error}'),
                    ElevatedButton(
                      onPressed: () => provider.listenToNotes(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.notes.isEmpty) {
              return const Center(
                child: Text(
                  'No notes yet\nTap + to add a new note',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index];
                const colors = [
                  Color.fromARGB(255, 255, 89, 0),
                  Color.fromARGB(255, 114, 6, 160),
                  Color.fromARGB(255, 14, 204, 30),
                  Color.fromARGB(255, 67, 97, 238),
                  Color.fromARGB(255, 225, 25, 75),
                  Color.fromARGB(255, 174, 230, 6),
                ];

                final cardColor = colors[index % colors.length];

                return GestureDetector(
                  onTap: () {
                    _showFullNoteDialog(context, note);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cardColor.withOpacity(0.8),
                          cardColor.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['note'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(note['createdAt']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(note['createdAt']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.white.withOpacity(0.9),
                              elevation: 8,
                              offset: const Offset(0, -100),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.blue,
                                    ),
                                    title: const Text(
                                      'Edit Note',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showEditNoteDialog(
                                        context,
                                        note['id'],
                                        note['note'],
                                      );
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      'Delete Note',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showDeleteConfirmation(
                                        context,
                                        note['id'],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddNoteDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

void _showFullNoteDialog(BuildContext context, Map<String, dynamic> note) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color(0xFF1D2671),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Note Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                note['note'],
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                "Created on: ${DateFormat('MMM dd, yyyy').format(note['createdAt'])}",
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Text(
                "At: ${DateFormat('hh:mm a').format(note['createdAt'])}",
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(context, note['id']);
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditNoteDialog(context, note['id'], note['note']);
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      "Edit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _handleLogout(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1D2671),
        title: const Text(
          'Logout Confirmation!',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully!',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Color.fromARGB(255, 39, 57, 195),
                  ),
                );

                Navigator.of(context).pushReplacementNamed('/login');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error logging out: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

void _showAddNoteDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 5, 36, 103),
        title: Text(
          'Add New Note',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your note...',
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            ),
            onPressed: () {
              final noteText = controller.text.trim();
              if (noteText.isNotEmpty) {
                context.read<HomeProvider>().addNote(noteText);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Note added successfully!'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.black,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void _showEditNoteDialog(
    BuildContext context, String noteId, String originalNoteText) {
  final TextEditingController controller =
      TextEditingController(text: originalNoteText);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 5, 36, 103),
        title: const Text(
          'Edit Note',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Edit your note...',
            hintStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final updatedNoteText = controller.text.trim();

              if (updatedNoteText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Note can\'t be empty',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                  ),
                );
                return;
              }

              if (updatedNoteText == originalNoteText) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('No changes made!',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                  ),
                );
                return;
              }
              context.read<HomeProvider>().updateNote(noteId, updatedNoteText);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Note updated successfully'),
                  backgroundColor: Colors.black,
                ),
              );

              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void _showDeleteConfirmation(BuildContext context, String noteId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 5, 36, 103),
        title: const Text(
          'Delete Note',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this note?',
          style: TextStyle(
              color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<HomeProvider>().deleteNote(noteId);
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(255, 5, 36, 103),
                    title: const Text(
                      'Deleted!',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'The note has been deleted successfully.',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
