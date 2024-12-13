import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:foodex/bottomNavigationScreen.dart';
import 'package:foodex/screen/getfood.dart';
import 'package:foodex/widgets/HomeScreen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String transactionId;
  final String date;
  final double totalWithFee;
  final String status;
  final int quantity;
  final String itemDescription;
  final int shopprice;
 

   PaymentSuccessScreen({Key? key, required this.transactionId, required this.date, required this.totalWithFee, required this.status, required this.quantity, required this.itemDescription, required this.shopprice,})
      : 
        super(key: key);

int calculateFoodexCommission() {
  return (totalWithFee - shopprice).round();
}
  @override
  Widget build(BuildContext context) {
    int foodexCommission = calculateFoodexCommission();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Payment Successful Text
              const Text(
                'Payment successful',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Successfully paid \₹${totalWithFee.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              // Payment Methods Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment methods',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Transaction Details Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailRow("Item", itemDescription),
                      _buildDetailRow('Item Amount', '₹${shopprice.toStringAsFixed(2)}'),
                      _buildDetailRow("Quantity", quantity.toString()),
                      _buildDetailRow("Total Amount", "₹${shopprice * quantity}"),
                      _buildDetailRow('Transaction ID', transactionId),
                      _buildDetailRow('Date', date),
                      _buildDetailRow('Platform Fee', '₹${foodexCommission.toStringAsFixed(2)}'),
                      _buildStatusRow('Status', status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Total Amount
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4242),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\₹${totalWithFee.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4242),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Getfood()),
                        (route) => false, // Removes all previous routes
                      );
                    },
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green[400],
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
