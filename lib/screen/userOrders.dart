import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


final db = FirebaseFirestore.instance;
final userid = FirebaseAuth.instance.currentUser!.email;
class usersOrders extends StatefulWidget {
  const usersOrders({super.key});

  @override
  State<usersOrders> createState() => _usersOrdersState();
}

class _usersOrdersState extends State<usersOrders> {

    String selectedArea = "";
  List restaurants = [];
  bool _loading = false; List<Map<String, dynamic>> orders = [];

  Future<void> loadUserData() async {
    final docRef = db.collection("consumer").doc(userid);
    try {
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("orders")) {
          setState(() {
            orders = List<Map<String, dynamic>>.from(data["orders"]);
          });
        }
      }
    } catch (e) {
      print("Error getting document: $e");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders found'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order['itemdescription']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${order['quantity']}'),
                      Text('Shop: ${order['shopname']}'),
                      Text('Price: \₹${order['totalprice']}'),
                      Text('Date: ${order['dateofproduce']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}