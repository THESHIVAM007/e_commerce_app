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
  List<Product> cartItems = [];
  List<Product> products = [];
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
   void addToCart(Product product) {
    setState(() {
      cartItems.add(product); // Assuming Product has an 'id' field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        title: const Text("HomePage",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 2),
                    ),
                  ],
        ),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CartScreen();
              }));
            },
            icon: const Icon(Icons.shopping_cart,color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              AuthRepo.logoutApp(context);
            },
            icon: const Icon(Icons.logout_outlined,color: Colors.white,),
          ),
        ],
      ),
      body: products.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.network(
                          products[index].imageUrl,
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index].name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              products[index].category,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              products[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${products[index].price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                              addToCart(products[index]);
                              },
                              child: const Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
          : const Center(child: Text("No products found")),
    );
  }
}
