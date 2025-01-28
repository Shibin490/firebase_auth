// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ForgetPasswordScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _resetPassword(BuildContext context) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: _emailController.text.trim());

//       // Show a success message to the user
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Password Reset"),
//             content: Text("A password reset link has been sent to your email."),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   Navigator.pop(context); // Close the dialog
//                   Navigator.pop(context); // Go back to the login screen
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       // Show error message if something goes wrong
//       showErrorDialog(context, e.toString());
//     }
//   }

//   void showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Error"),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color.fromARGB(255, 26, 5, 146),
//               const Color.fromARGB(255, 2, 7, 13),
//               const Color.fromARGB(255, 5, 19, 124),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     // Title
//                     Text(
//                       "Reset Password",
//                       style: TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 30),

//                     // Email input field
//                     TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         labelStyle: TextStyle(
//                           color: Colors.white, // Change the color of the label
//                           fontSize: 18, // Font size of the label
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     SizedBox(height: 20),

//                     // Reset Password button
//                     ElevatedButton(
//                       onPressed: () => _resetPassword(context),
//                       child: Text(
//                         "Send Reset Link",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(double.infinity, 50),
//                         backgroundColor: const Color.fromARGB(255, 49, 37, 132),
//                         textStyle: TextStyle(fontSize: 18),
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     // Back to login screen button
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context); // Go back to the login screen
//                       },
//                       child: Text(
//                         "Back to login",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
