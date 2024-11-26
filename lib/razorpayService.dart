import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;


  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  
  }

  
  final String _baseUrl = 'https://api.razorpay.com/v1/orders';
  final String _keyId = 'rzp_test_0R7MGhoYIHHFTi';
  final String _keySecret = 'VQv09stqgGyID3id7SM187WX';

  Future<Map<String, dynamic>> createOrder(int amount, String Acc1, String Acc2, String Acc1_branch, String Acc1_name) async {
    try {
      int amountInPaise =(amount * 100);
      final Map<String, dynamic> orderData = {
        "amount": amountInPaise.toInt(),
        "currency": "INR",
        "transfers": [
          {
            "account": Acc1,
            "amount": (amountInPaise*0.9).toInt(),
            "currency": "INR",
            "notes": {"branch": Acc1_branch, "name": Acc1_name},
            "linked_account_notes": ["branch"],
            "on_hold": 0,
          },
          {
            "account": Acc2,
            "amount": (amountInPaise*0.1).toInt(),
            "currency": "INR",
            "notes": {"branch": "Platform Commission", "name": "Foodex"},
            "linked_account_notes": ["branch"],
            "on_hold": 0
          }
        ]
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Basic ' + base64Encode(utf8.encode('$_keyId:$_keySecret'))},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        print("---------------------------------------------createOrder");
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create Razorpay order: ${response.body}');
      }
    } catch (e) {
      print('Error creating Razorpay order: $e');
      rethrow;
    }
  }

  Future<void> initiatePayment(int amount, String orderID) async {
    if (amount == null || orderID == null) {
      throw Exception("Amount and Order ID cannot be null");
    }
    var options = {
      'key': 'rzp_test_0R7MGhoYIHHFTi',
      'amount': amount, // in paise
      'name': 'Foodex Payments',
      'order_id': orderID,
      'description': 'Food Payment',
      'timeout': 120, // in seconds
      'prefill': {'contact': '1234567890', 'email': 'foodexbusinessindia@gmail.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Payment Initiation Error: $e');
      rethrow;
    }
  }

  // Example usage in a method
  Future processOrder(int amount, String Acc1, String Acc2, String Acc1_branch, String Acc1_name, String shopName) async {
    try {
      print("------------------------------------------------processOrder");
      final orderResponse = await createOrder(amount, Acc1, Acc2, Acc1_branch, Acc1_name);
      await initiatePayment(orderResponse["amount"], orderResponse["id"]);

      
        // print(jsonEncode(orderResponse));
      print('Order created: ${orderResponse['id']}');
      final List<Map<String, dynamic>> transferDetails = [];

      // Process transfers
      if (orderResponse['transfers'] != null) {
        for (var transfer in orderResponse['transfers']) {
          transferDetails.add({
            "Transfer ID": transfer["id"],
            "Recipient ID": transfer["recipient"],
            "Amount": transfer["amount"],
            "Notes_branch": transfer["notes"]["branch"],
            "Notes_name": transfer["notes"]["name"],
          });
         print(transfer["amount"].runtimeType);
        }
        
        
         
      }
      final orderData =  {
          "Order ID": orderResponse["id"],
          "Total Amount": orderResponse["amount"],
          "Transfers": transferDetails,
        };
          print((orderData["Total Amount"]).runtimeType);
          print((orderData["Order ID"]).runtimeType);
         
    } catch (e) {
      print('initiate payment failed: $e');
      rethrow;
    
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Verify payment details
    print("----------------------------response------------------");
print("Payment Success Response:");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    return;
   
    //{razorpay_signature: d2c46864404898dd50d82293f85c026a32b23efd0758d0f93f31b43a8a10bd29,
    // razorpay_order_id: order_POphDKSuDb0ddf,
    // razorpay_payment_id: pay_POphL178rz0S3S}
  

  }


  void _handlePaymentError(PaymentFailureResponse response) {
print('Payment Error: ${response.message}');
    print('Error Code: ${response.code}');    
    return;
    // Handle payment failure
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    return;
    // Handle external wallet selection
  }

}