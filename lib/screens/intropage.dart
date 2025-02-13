// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:authenticationapp/controller/intro_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
 

class ToDoListIntro extends StatelessWidget {
  const ToDoListIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final introProvider = Provider.of<IntroProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 26, 5, 146),
              const Color.fromARGB(255, 2, 7, 13),
              const Color.fromARGB(255, 5, 19, 124),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sticky_note_2_rounded,
                  color: Colors.white,
                  size: 120,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "MAKE NOTES",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "write down your thoughts",
                  style: GoogleFonts.poppins(
                    color: Colors.blue.shade200,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                introProvider.isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : ElevatedButton.icon(
                        icon: Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Get Started",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          introProvider.startLoading();

                          await Future.delayed(Duration(seconds: 2));
                          introProvider.stopLoading();
                          Navigator.pushNamed(context, '/signup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 36, 36, 199),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 30.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          shadowColor: Colors.black.withOpacity(0.2),
                          elevation: 5,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
