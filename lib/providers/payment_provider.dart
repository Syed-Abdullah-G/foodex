import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodex/models/ordersModel.dart';
import 'package:foodex/providers/razorpay_update.dart';
import 'package:foodex/screen/PaymentSuccessfulScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';

final db = FirebaseFirestore.instance;

class RazorpayService {
  final WidgetRef ref;
  late Razorpay _razorpay;
  final BuildContext context;

  RazorpayService(this.ref, this.context) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  final String _baseUrl = 'https://api.razorpay.com/v1/orders';
  final String _keyId = 'rzp_test_0R7MGhoYIHHFTi';
  final String _keySecret = 'VQv09stqgGyID3id7SM187WX';

  Future<Map<String, dynamic>> createOrder(int amount, String Acc1, String Acc2, String Acc1_branch, String address) async {
    try {
      int amountInPaise = (amount * 100);
      final Map<String, dynamic> orderData = {
        "amount": amountInPaise.toInt(),
        "currency": "INR",
        "transfers": [
          {
            "account": Acc1,
            "amount": (amountInPaise*0.9).toInt(),
            "currency": "INR",
            "notes": {"branch": Acc1_branch, "name": address},
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
        headers: {
          'Content-Type': 'application/json', 
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$_keyId:$_keySecret'))
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        final orderResponse = jsonDecode(response.body);
        
        ref.read(razorpayOrderProvider.notifier).updateOrderDetails(orderResponse,0,"","", "",0,"");
        
        return orderResponse;
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

  Future<void> processOrder(int amount, String Acc1, String Acc2, String Acc1_branch, String address, String shopName, int quantitypurchased, String itemdescription, String area, String userID, int shopprice, String shopname) async {
    try {
          final paymentData = ref.read(razorpayOrderProvider.notifier);


      final orderResponse = await createOrder(amount, Acc1, Acc2, Acc1_branch, address);
      paymentData.updateOrderDetails(orderResponse, quantitypurchased, itemdescription,area, userID, shopprice, shopname);
      await initiatePayment(orderResponse["amount"], orderResponse["id"]);
    } catch (e) {
      print('initiate payment failed: $e');
      rethrow;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final paymentData = ref.read(razorpayOrderProvider);
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        final formattedDate = formatter.format(now);
        print("---------------------");
    print(paymentData.area);
    print(paymentData.userid);
    final docRef = db.collection(paymentData.area!).doc(paymentData.userid!);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Get the current fooditems array
      List<dynamic> foodItems = docSnapshot.data()?['fooditems'] ?? [];
      print("------------------------------------------_$foodItems");

      // Find the index of the item with matching itemDescription
      int itemIndex = foodItems.indexWhere(
        (item) => item['itemDescription'] == paymentData.itemDescription
      );

      // If item is found, update its quantity
      if (itemIndex != -1) {
        // Create a copy of the item to modify
        Map<String, dynamic> updatedItem = Map.from(foodItems[itemIndex]);
        
        // Update the quantity (assuming the current quantity is subtracted from the  the new purchase quantity)
        int currentQuantity = updatedItem['quantity'] ?? 0;
        updatedItem['quantity'] = currentQuantity - paymentData.quantitypurchased!;

        // Replace the old item with the updated item
        foodItems[itemIndex] = updatedItem;

        // Update the document with the modified fooditems array
        await docRef.update({
          'fooditems': foodItems
        });
      }
    }

    final orderModel  = OrdersModel(dateOfProduce: formattedDate, itemDescription: paymentData.itemDescription!, quantity: paymentData.quantitypurchased.toString(), shopname: paymentData.shopname!, totalPrice:  paymentData.amount.toString());
    Map<String, dynamic> ordersMap = orderModel.toJson();

    await db.collection("consumer").doc(paymentData.userid).update({
      "orders": FieldValue.arrayUnion([ordersMap]),
    });



        Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          transactionId: response.paymentId ?? 'N/A',
          date: formattedDate,
          totalWithFee: paymentData.amount != null ? paymentData.amount! / 100.0 : 0.0,
          status: 'Success',
          quantity: paymentData.quantitypurchased!, itemDescription: paymentData.itemDescription!, shopprice: paymentData.shopprice!,
   ),
      ),
      (route) => false,
    );


    print("Payment Success Response:");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.message}');
    print('Error Code: ${response.code}');    
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }
}