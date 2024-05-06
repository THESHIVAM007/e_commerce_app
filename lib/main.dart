import 'package:e_commerce_app/screen/homepage.dart';
import 'package:e_commerce_app/screen/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if the user is already logged in
  User? user = FirebaseAuth.instance.currentUser;
  runApp(ProviderScope(child: MyApp(curruser: user)));
}

class MyApp extends StatelessWidget {
  final User? curruser;

  const MyApp({Key? key, this.curruser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Use conditional operator to determine which screen to show
      home: curruser == null ? const LoginPage() : const HomePage(),
    );
  }
}
