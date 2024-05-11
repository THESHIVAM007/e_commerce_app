import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;  // Pass the orderId when navigating to this page

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          backgroundColor: Colors.purple,
        ),
        body: const Center(child: Text("You are not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.purple,
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
            return const Center(child: Text('Error loading order details'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No order found'));
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>?; // Safe cast as nullable Map
          if (orderData == null) { // Additional null check
            return const Center(child: Text('Order data is not available'));
          }

          var products = List<Map<String, dynamic>>.from(orderData['products'] as List<dynamic>);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Order ID: ${snapshot.data!.id}', style: Theme.of(context).textTheme.titleLarge),
                  Text('Total Amount: \$${orderData['totalAmount']}', style: Theme.of(context).textTheme.titleLarge),
                  Text('Status: ${orderData['orderStatus']}', style: Theme.of(context).textTheme.titleLarge),
                  Text('Order Date: ${TimestampToDate(orderData['orderDate'] as Timestamp)}', ),
                  const Divider(),
                  const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(products[index]['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${products[index]['description']}'),
                            Text('Quantity: ${products[index]['qty']}'),
                          ],
                        ),
                        trailing: Text('\$${products[index]['price']}'),
                        leading: Image.network(products[index]['imageUrl'], width: 50, fit: BoxFit.cover),
                      );
                    },
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to previous screen
                    },
                    child: const Text('Back to Orders'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

 String TimestampToDate(Timestamp timestamp) {
  DateTime date = timestamp.toDate(); // Convert Firestore Timestamp to DateTime
  return "${date.day}/${date.month}/${date.year}"; // Customize this format as needed
}

}
