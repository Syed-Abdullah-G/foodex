import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Food item model class
class FoodItem {
  final String name;
  final String imageUrl;
  final double price;

  FoodItem({required this.name, required this.imageUrl, required this.price});
}

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<FoodItem> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .collection('food_items')
          .get();

      setState(() {
        _foodItems = snapshot.docs.map((doc) {
          return FoodItem(
            name: doc['name'],
            imageUrl: doc['imageUrl'],
            price: doc['price'].toDouble(),
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching food items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
      ),
      body: _foodItems.isNotEmpty
          ? ListView.builder(
              itemCount: _foodItems.length,
              itemBuilder: (context, index) {
                FoodItem item = _foodItems[index];
                return ListTile(
                  leading: Image.network(item.imageUrl),
                  title: Text(item.name),
                  trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}