// import 'package:cloud_firestore/cloud_firestore.dart';

// class Note {
//   final String id;
//   final String noteContent;
//   final DateTime createdAt;

//   Note({
//     required this.id,
//     required this.noteContent,
//     required this.createdAt,
//   });

//   factory Note.fromDocument(DocumentSnapshot doc) {
//     return Note(
//       id: doc.id,
//       noteContent: doc['note'],
//       createdAt: doc['createdAt'].toDate(),
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'note': noteContent,
//       'createdAt': createdAt,
//     };
//   }
// }
