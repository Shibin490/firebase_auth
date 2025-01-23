// import 'package:authenticationapp/forgetpassword.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'home.dart';
// import 'loginpage.dart';

// class SignUp extends StatelessWidget {
//   SignUp({super.key});

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<void> signUpWithGoogle(BuildContext context) async {
//     try {
//       GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser != null) {
//         GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//         OAuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         await FirebaseAuth.instance.signInWithCredential(credential);
//         Navigator.pushReplacement(context, CustomPageRoute(child: Home()));
//       }
//     } catch (e) {
//       showErrorSnackBar(context, 'google-sign-up-failed');
//     }
//   }

//   Future<void> signUpUser(
//       String email, String password, String name, BuildContext context) async {
//     try {
//       // Create user with email and password
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Save the email and name to Firestore
//       await FirebaseFirestore.instance
//           .collection('registeredUsers')
//           .doc(userCredential.user?.uid)
//           .set({
//         'email': email,
//         'name': name,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           backgroundColor: Colors.green,
//           content: Text(
//             "Account created successfully!",
//             style: TextStyle(fontSize: 18.0),
//           )));

//       // Navigate to the home screen after successful sign-up
//       Navigator.pushReplacement(context, CustomPageRoute(child: Home()));
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red,
//           content: Text(
//             e.message ?? "An error occurred",
//             style: const TextStyle(fontSize: 18.0),
//           )));
//     }
//   }

//   void showErrorSnackBar(BuildContext context, String code) {
//     String message = "An error occurred";
//     if (code == 'google-sign-up-failed') {
//       message = "Google sign up failed";
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(10),
//         backgroundColor: Colors.deepOrange.shade400,
//         content: Text(
//           message,
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             color: Colors.white,
//           ),
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.yellow.shade100,
//               Colors.orange.shade100,
//               Colors.deepOrange.shade100,
//             ],
//             stops: const [0.0, 0.5, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0, end: 1),
//                     duration: const Duration(milliseconds: 800),
//                     builder: (context, double value, child) {
//                       return Opacity(
//                         opacity: value,
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.arrow_back_ios_rounded,
//                             color: Colors.deepOrange.shade400,
//                           ),
//                           onPressed: () => Navigator.pushReplacement(
//                             context,
//                             CustomPageRoute(child: LogIn()),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0, end: 1),
//                     duration: const Duration(milliseconds: 1000),
//                     builder: (context, double value, child) {
//                       return Transform.scale(
//                         scale: value,
//                         child: Center(
//                           child: Column(
//                             children: [
//                               ShaderMask(
//                                 shaderCallback: (bounds) => LinearGradient(
//                                   colors: [
//                                     Colors.orange.shade700,
//                                     Colors.deepOrange.shade900,
//                                   ],
//                                 ).createShader(bounds),
//                                 child: Text(
//                                   "Create Account",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 1200),
//                           builder: (context, double value, child) {
//                             return Transform.translate(
//                               offset: Offset(0, 50 * (1 - value)),
//                               child: Opacity(
//                                 opacity: value,
//                                 child: buildInputField(
//                                   controller: nameController,
//                                   hintText: "Name",
//                                   icon: Icons.person_rounded,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 1400),
//                           builder: (context, double value, child) {
//                             return Transform.translate(
//                               offset: Offset(0, 50 * (1 - value)),
//                               child: Opacity(
//                                 opacity: value,
//                                 child: buildInputField(
//                                   controller: emailController,
//                                   hintText: "Email",
//                                   icon: Icons.email_rounded,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 1600),
//                           builder: (context, double value, child) {
//                             return Transform.translate(
//                               offset: Offset(0, 50 * (1 - value)),
//                               child: Opacity(
//                                 opacity: value,
//                                 child: buildInputField(
//                                   controller: passwordController,
//                                   hintText: "Password",
//                                   icon: Icons.lock_rounded,
//                                   obscureText: true,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 40),
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 1800),
//                           builder: (context, double value, child) {
//                             return Transform.scale(
//                               scale: value,
//                               child: buildSignUpButton(context),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 30),
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 2000),
//                           builder: (context, double value, child) {
//                             return Opacity(
//                               opacity: value,
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     "Or sign up with",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.grey.shade600,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                   GestureDetector(
//                                     onTap: () => signUpWithGoogle(context),
//                                     child: Container(
//                                       padding: EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(15),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                                 Colors.black.withOpacity(0.1),
//                                             blurRadius: 10,
//                                             offset: Offset(0, 5),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Icon(
//                                         Icons.g_mobiledata,
//                                         size: 30,
//                                         color: Colors.deepOrange.shade400,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 40),
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 2200),
//                           builder: (context, double value, child) {
//                             return Opacity(
//                               opacity: value,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Already have an account?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pushReplacement(context,
//                                           CustomPageRoute(child: LogIn()));
//                                     },
//                                     child: Text(
//                                       "Login",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.deepOrange.shade400,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInputField(
//       {required TextEditingController controller,
//       required String hintText,
//       required IconData icon,
//       bool obscureText = false}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           icon: Icon(icon, color: Colors.deepOrange.shade400),
//           hintText: hintText,
//           border: InputBorder.none,
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return '$hintText is required';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget buildSignUpButton(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//         backgroundColor: Colors.deepOrange.shade400,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       onPressed: () {
//         if (_formKey.currentState?.validate() ?? false) {
//           signUpUser(
//             emailController.text.trim(),
//             passwordController.text.trim(),
//             nameController.text.trim(),
//             context,
//           );
//         }
//       },
//       child: Text(
//         "Sign Up",
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//           fontSize: 18,
//         ),
//       ),
//     );
//   }
// }
