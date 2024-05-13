import 'package:e_commerce_app/screen/homepage.dart';
import 'package:e_commerce_app/screen/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Setting a basic color similar to #EE9002
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEE9002), // Main theme color
          primary: const Color(0xFFEE9002), // AppBar, buttons, etc.
          secondary: const Color(0xFFF3B566), // Another shade for contrast
          onPrimary: Colors.white, // Text color on top of primary color
          surface: Colors.white, // Card and dialog backgrounds
          onSurface: Colors.black, // Text color on top of surfaces
          background: Colors.white, // App background color
          onBackground: Colors.black, // Text color on background
        ),
        useMaterial3: true,
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFFF3B566), // Lighter shade for buttons
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: _getUserStatus(),
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return snapshot.data ?? const LoginPage();
          },
        ),
      ),
    );
  }

  // Function to determine which page to navigate to based on user status
  Future<Widget> _getUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    } else {
      // Check if the user exists in the Firestore users collection
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        // User is authenticated but not in Firestore users collection
        return const LoginPage(); 
      } else {
        // User exists in users collection
        return const HomePage();
      }
    }
  }
}