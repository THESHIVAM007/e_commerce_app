import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/screen/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userCredential});
  final UserCredential userCredential;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String address = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserToFirestore() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String phoneNumber = widget.userCredential.user!.phoneNumber!;
      String uid = widget.userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'uid': uid,
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Profile updated successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Information'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) => fullName = value ?? '',
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) => address = value ?? '',
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: addUserToFirestore,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
