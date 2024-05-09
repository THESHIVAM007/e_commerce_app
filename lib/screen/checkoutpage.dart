import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/screen/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_app/provider/cart_provider.dart'; 

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  Future<void> createOrder() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("No user logged in."),
    ));
    return;
  }

  final cartProducts = ref.read(cartProductProvider);
  if (cartProducts.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Cart is empty."),
    ));
    return;
  }

  try {
    final orderData = {
      'userId': user.uid,
      'orderDate': Timestamp.now(),
      'products': cartProducts.map((product) => {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'qty': product.qty,
        'imageUrl': product.imageUrl,
        'description': product.description,
      }).toList(),
      'totalAmount': cartProducts.fold<double>(0.0, (sum, item) => sum + item.price * item.qty),
      'orderStatus': 'Pending', // Example status
      // Add other order details here as needed
    };

    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('orders').add(orderData);

  showOrderSuccessDialog();

  } catch (e) {
    print('Error creating order: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Failed to create order: $e"),
    ));
  }
}
void showOrderSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Order Successful"),
        content: const Text("Your order has been placed successfully."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Assuming the home page is where shopping continues
              Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage(),));
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cartTotal = ref.watch(cartProductProvider).fold<double>(
        0.0, (sum, item) => sum + item.price * item.qty);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Checkout Page", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Text("Document does not exist");
          }
      
          var userData = snapshot.data!.data() as Map<String, dynamic>;
      
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("User name", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(userData['fullName'] ?? 'Not available', style: TextStyle(color: Colors.grey[600])),
                ),
                ListTile(
                  title: const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(userData['phoneNumber'] ?? 'Not available', style: TextStyle(color: Colors.grey[600])),
                ),
                ListTile(
                  title: const Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(userData['address'] ?? 'Not available', style: TextStyle(color: Colors.grey[600])),
                ),
                ListTile(
                  title: const Text("Cart Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("\$${cartTotal.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey[600])),
                ),
                // const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      onPressed: createOrder,
                      child: const Text("Proceed to Pay", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
