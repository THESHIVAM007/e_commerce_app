import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/screen/orderdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: user == null
        ? const Center(child: Text("You are not logged in"))
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('orders')
                .orderBy('orderDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong', style: theme.textTheme.titleLarge));
              }
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No orders found', style: theme.textTheme.titleLarge));
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  var orderData = doc.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Order ID: ${doc.id}', style: theme.textTheme.titleMedium),
                      subtitle: Text('Total: ₹${orderData['totalAmount']}', style: theme.textTheme.titleMedium),
                      trailing: Chip(
                        label: Text(orderData['orderStatus'], style: TextStyle(color: theme.colorScheme.onPrimary)),
                        backgroundColor: orderData['orderStatus'] == 'Pending' ? Colors.orange : Colors.green,
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(orderId: doc.id),
                      )),
                    ),
                  );
                }).toList(),
              );
            },
          ),
    );
  }
}
