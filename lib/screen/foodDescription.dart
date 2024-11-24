import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:foodex/models/OrderResponse.dart';
import 'package:foodex/razorpayService.dart';
import 'package:foodex/screen/PaymentSuccessfulScreen.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class FoodDetailCard extends StatefulWidget {
  FoodDetailCard({required this.area, required this.account, required this.shopNumber, required this.shopName, required this.shopAddress, required this.itemDescription, required this.imageUrl, required this.price, required this.quantity});

  String area;
  String account;
  String shopNumber;
  String shopName; //used
  String shopAddress; //used
  String itemDescription; // used
  String imageUrl; //used
  int price; //used
  int quantity; // used

  @override
  State<FoodDetailCard> createState() => _FoodDetailCardState();
}

class _FoodDetailCardState extends State<FoodDetailCard> {
  late int quantityController = 0;
  int totalAmount = 0;
  final _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController = 1;
    totalAmount = widget.price;
   
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
                                      });
                                    }
                                    totalAmount = widget.price * quantityController;
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
                                      });
                                    }
                                    totalAmount = widget.price * quantityController;
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
                                '\₹${(widget.price * quantityController).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                  final userData = await RazorpayService().processOrder(totalAmount, widget.account, "acc_PG7uLBTqV9HqN7","fresh and tasty","Ram Kumar", widget.shopName);
                                 final orderId  = userData["Order ID"];
                                 final Total_Amount  = userData["Total Amount"];
                                 final Transfers  = userData["Transfers"];
                                 final transfer_1_data = Transfers["Transfer ID"];
                                 final transfer_1_recipient_ID = Transfers["Recipient ID"];
                                 final transfer_1_amount = Transfers["Amount"];
                                 final transfer_1_branch = Transfers["Notes_branch"];
                                 final transfer_1_notes = Transfers["Notes_name"];


                                if (!context.mounted) return;
                                final now = DateTime.now();
                                final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
                                final formatted = formatter.format(now);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PaymentSuccessScreen(transactionId: orderId.toString(), date: formatted, nominal: totalAmount.toDouble(),status: "Success", total:totalAmount.toDouble()),
                                ));
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
