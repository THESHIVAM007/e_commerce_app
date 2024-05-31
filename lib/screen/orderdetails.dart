import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId; // Pass the orderId when navigating to this page

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Use the theme for consistent styling
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          backgroundColor: theme.colorScheme.primary,
        ),
        body: const Center(child: Text("You are not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading order details',
                    style: theme.textTheme.titleLarge));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No order found'));
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>?;
          if (orderData == null) {
            return const Center(child: Text('Order data is not available'));
          }

          var products = List<Map<String, dynamic>>.from(
              orderData['products'] as List<dynamic>);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Order ID: ${snapshot.data!.id}',
                    style: theme.textTheme.titleLarge),
                Text('Total Amount: ₹ ${orderData['totalAmount']}',
                    style: theme.textTheme.titleLarge),
                Text('Status: ${orderData['orderStatus']}',
                    style: theme.textTheme.titleLarge),
                Text(
                    'Order Date: ${TimestampToDate(orderData['orderDate'] as Timestamp)}',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 20),
                const Text('Products',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ...products
                    .map((product) => ListTile(
                          title: Text(product['name'],
                              style: theme.textTheme.titleMedium),
                          subtitle: Text(
                              'Quantity: ${product['qty']} x ₹${product['price']} each',
                              style: theme.textTheme.titleMedium),
                          leading: CachedNetworkImage(
                              imageUrl: product['imageUrl'],
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                              key: UniqueKey(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover),
                          isThreeLine: true,
                        ))
                    .toList(),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSurface),
                  onPressed: () =>
                      Navigator.pop(context), // Go back to previous screen
                  child: const Text('Back to Orders'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String TimestampToDate(Timestamp timestamp) {
    DateTime date =
        timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    return "${date.day}/${date.month}/${date.year}"; // Customize this format as needed
  }
}
