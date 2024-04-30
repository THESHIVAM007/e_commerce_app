import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:e_commerce_app/screen/cartscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> getProducts() async {
    await db.collection("products").get()
      .then((event) {
        for (var doc in event.docs) {
          print("${doc.id} => ${doc.data()}");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("HomePage"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CartScreen();
              }));
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              AuthRepo.logoutApp(context);
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: const Center(
        child: Text("Homepage.."),
      ),
    );
  }
}
