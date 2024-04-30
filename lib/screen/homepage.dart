import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/screen/cartscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    super.initState();
  }
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Product> products = [];
  Future<void> getProducts() async {
    try {
      await db.collection("products").get().then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          Product newProduct = Product.fromFirestore(doc.data());
          print(newProduct);
          products.add(newProduct);
        }
        setState(() {});
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
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
      body: Center(
        child: Column(
          children: [
            const Text("Homepage.."),
            // ElevatedButton(
            //   onPressed: getProducts,
            //   child: const Text("get data"),
            // ),
            products.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:Text( products[index].name),
                        leading: Text("${products[index].price}"),
                        subtitle: Text(products[index].category),
                      );
                    })
                : const Text("NoProd found"),
          ],
        ),
      ),
    );
  }
}
