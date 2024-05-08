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
    // Check if the form is valid before proceeding
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Retrieve the phone number and uid from the UserCredential
      String phoneNumber = widget.userCredential.user!.phoneNumber!;
      String uid = widget.userCredential.user!.uid;

      // Add the user information to Firestore
      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'uid': uid,
      });

      // Inform the user with a dialog
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Profile updated successfully!'),
          );
        },
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Information'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    fullName = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    address = value!;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: addUserToFirestore,
                    child: const Text('Submit'),
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
