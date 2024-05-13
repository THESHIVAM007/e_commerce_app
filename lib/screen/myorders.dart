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
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.purple,
      ),
      body: user == null
        ? const Center(child: Text("You are not logged in"))
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('orders')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No orders found'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var order = snapshot.data!.docs[index];
                  var orderData = order.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: Text('Total: ₹ ${orderData['totalAmount']}'),
                    trailing: Text('Status: ${orderData['orderStatus']}'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(orderId: order.id),));
                    },
                  );
                },
              );
            },
          ),
    );
  }
}
