import 'package:authenticationapp/controller/auth_wrapper.dart';
import 'package:authenticationapp/screens/verification%20screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authenticationapp/controller/cloud_provider.dart';
import 'package:authenticationapp/screens/cloud_homescreen.dart';
import 'package:authenticationapp/screens/home_screeen.dart';
import 'package:authenticationapp/controller/home_provider.dart';
import 'package:authenticationapp/controller/intro_provider.dart';
import 'package:authenticationapp/controller/login_provider.dart';
import 'package:authenticationapp/controller/reset_provider.dart';
import 'package:authenticationapp/controller/signup_provider.dart';
import 'package:authenticationapp/screens/login.dart';
import 'package:authenticationapp/screens/reset_pass.dart';
import 'package:authenticationapp/screens/signup.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => IntroProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
      ],
      child: MyApp(isLoggedIn: currentUser != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Firebase Authentication & Notes App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: const Color.fromARGB(255, 4, 15, 163),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 4, 15, 163),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: AuthWrapper(),
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/verification': (context) => VerificationScreen(),
        '/home': (context) => HomeScreen(),
        '/s3-home': (context) => UploadScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
      },
    );
  }
}
