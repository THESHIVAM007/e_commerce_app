import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/provider/cart_provider.dart';
import 'package:e_commerce_app/screen/cartscreen.dart';
import 'package:e_commerce_app/screen/myorders.dart';
import 'package:e_commerce_app/widget/productcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    var count = ref.watch(cartProductProvider).length;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 50,),
            ListTile(
              title: Text("My Orders", style: TextStyle(color: theme.primaryColor)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyOrdersPage()));
              },
            ),
            ListTile(
              title: Text("Log Out", style: TextStyle(color: theme.primaryColor)),
              onTap: () {
                AuthRepo.logoutApp(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "HomePage",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: theme.colorScheme.onPrimary,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon:  Badge(
              label: Text("$count"),
              child: const Icon(Icons.shopping_cart)),
            color: theme.colorScheme.onPrimary,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
              if (result == true) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: products.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .5,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              })
          : const Center(child: Text("No products found", style: TextStyle(color: Colors.black))),
    );
  }
}
