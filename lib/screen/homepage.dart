import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:e_commerce_app/screen/cartscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
