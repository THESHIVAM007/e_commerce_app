import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/screen/cartscreen.dart';
import 'package:e_commerce_app/widget/productcard.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      await db.collection("products").get().then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          Product newProduct = Product.fromFirestore(doc.data());
          print(newProduct.imageUrl);
          products.add(newProduct);
        }
        setState(() {});
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }


  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        title: const Text(
          "HomePage",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return  const CartScreen();
              }));
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              AuthRepo.logoutApp(context);
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: products.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              })
          : const Center(child: Text("No products found")),
    );
  }
}
