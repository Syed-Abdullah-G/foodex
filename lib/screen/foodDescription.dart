import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodex/models/paymentFood.dart';
import 'package:foodex/providers/payment_provider.dart';
import 'package:foodex/razorpayService.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDetailCard extends ConsumerStatefulWidget {
  FoodDetailCard({required this.area, required this.account, required this.shopNumber, required this.shopName, required this.shopAddress, required this.itemDescription, required this.imageUrl, required this.quantity, required this.userid, required this.shopprice});

  String area;
  String account; //used
  String shopNumber;
  String shopName; //used
  String shopAddress; //used
  String itemDescription;
  String imageUrl; //used
  int quantity; // used
  String userid;
  int shopprice;

  @override
  ConsumerState<FoodDetailCard> createState() => _FoodDetailCardState();
}

class _FoodDetailCardState extends ConsumerState<FoodDetailCard> {
  late int quantityController = 0;
  int totalAmount = 0;
  final _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController = 1;
    totalAmount = (widget.shopprice * quantityController * 1.07).round(); // calculate initital total with 7%
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Food Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Image.network(
                    widget.imageUrl, // Replace with your image URL
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Counter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.itemDescription,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${widget.quantity.toInt().toString()} Left",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Counter
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantityController > 1) {
                                      setState(() {
                                        quantityController--;
                      totalAmount = (widget.shopprice * quantityController * 1.07).round(); // Update total with 7%
                                      });
                                    }
                                  },
                                  color: Colors.grey[600],
                                ),
                                Text(
                                  quantityController.toInt().toString(),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    if (quantityController < widget.quantity) {
                                      setState(() {
                                        quantityController++;
                                                              totalAmount = (widget.shopprice * quantityController * 1.07).round(); // Update total with 7%

                                      });
                                    }
                                  },
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Nutritional Info
                      Row(
                        children: [
                          Icon(Icons.store),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.shopName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.shopAddress,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Total and Add to Cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total amount',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Text(
                                '\₹${(totalAmount).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                // final userData = await RazorpayService().processOrder(totalAmount, widget.account, "acc_PG7uLBTqV9HqN7","fresh and tasty","Ram Kumar", widget.shopName);
                                final razorpayService = RazorpayService(ref, context);
                                razorpayService.processOrder(totalAmount, widget.account, "acc_PG7uLBTqV9HqN7", widget.shopName, widget.shopAddress, widget.shopName, quantityController, widget.itemDescription, widget.area, widget.userid, widget.shopprice, widget.shopName);
                              } catch (e) {
                                print("Payment initiation failed: $e");
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Payment failed: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDBF666),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text('Order'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
