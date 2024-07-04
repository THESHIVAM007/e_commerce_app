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
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final cartTotal = ref
        .watch(cartProductProvider)
        .fold<double>(0.0, (sum, item) => sum + item.price * item.qty);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: const Text("Checkout",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Something went wrong",
                style: theme.textTheme.titleLarge);
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Text("Document does not exist");
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                UserDetailsTile(
                    userData: userData, title: "User name", detail: 'fullName'),
                UserDetailsTile(
                    userData: userData,
                    title: "Phone Number",
                    detail: 'phoneNumber'),
                UserDetailsTile(
                    userData: userData, title: "Address", detail: 'address'),
                ListTile(
                  title: const Text("Cart Total",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("₹${cartTotal.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.grey[600])),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary),
                    onPressed: createOrder,
                    child: const Text("Proceed to Pay",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget UserDetailsTile(
      {required Map<String, dynamic> userData,
      required String title,
      required String detail}) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      title: Text(title,
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(userData[detail] ?? 'Not available',
          style: theme.textTheme.titleMedium),
    );
  }

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
        'products': cartProducts
            .map((product) => {
                  'id': product.id,
                  'name': product.name,
                  'price': product.price,
                  'qty': product.qty,
                  'imageUrl': product.imageUrl,
                  'description': product.description,
                })
            .toList(),
        'totalAmount': cartProducts.fold<double>(
            0.0, (sum, item) => sum + item.price * item.qty),
        'orderStatus': 'Pending', // Example status
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add(orderData);
      ref.watch(cartProductProvider.notifier).emptyCart();
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  ModalRoute.withName('/home'),
                );
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }
}
