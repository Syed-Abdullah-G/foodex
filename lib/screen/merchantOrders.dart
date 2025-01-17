import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


final db = FirebaseFirestore.instance;
final userid = FirebaseAuth.instance.currentUser!.email;
class merchantOrders extends StatefulWidget {
  const merchantOrders({super.key});

  @override
  State<merchantOrders> createState() => _usersOrdersState();
}

class _usersOrdersState extends State<merchantOrders> {

    String selectedArea = "";
  List restaurants = [];
  final bool _loading = false; List<Map<String, dynamic>> orders = [];

  Future<void> loadUserData() async {
    final docRef = db.collection("user").doc(userid);
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
   return Scaffold(backgroundColor: Colors.white,resizeToAvoidBottomInset: true,
      body: orders.isEmpty
          ?  Center(
              child: Text('No orders found',style: TextStyle(
                fontSize: 18.sp,color: Colors.grey
              ),),
            )
          : ListView.builder(
            padding: EdgeInsets.all(10.r),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order);
              },
            ),
    );
  }
}

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Description
              Text(
                order['itemdescription'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),

              // Order Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          Icons.store, 'Shop: ${order['shopname']}'),
                      _buildDetailRow(
                          Icons.shopping_basket, 'Quantity: ${order['quantity']}'),
                      _buildDetailRow(
                          Icons.currency_rupee, 'Price: ₹${order['totalprice']}'),
                      _buildDetailRow(
                          Icons.calendar_today, 'Date: ${order['dateofproduce']}'),
                    ],
                  ),
                  // Optional: Add an order status icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
