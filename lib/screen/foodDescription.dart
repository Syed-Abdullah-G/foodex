import 'dart:convert';
import 'package:foodex/models/OrderResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

final _razorpay = Razorpay();

class Fooddescription extends StatefulWidget {
    Fooddescription({
    required this.area,
    required this.account,
    required this.shopNumber,
    required this.shopName,
    required this.shopAddress,
    required this.itemDescription,
    required this.imageUrls,
    required this.price
  });


  String area;
  String account;
  String shopNumber;
  String shopName;
  String shopAddress;
  String itemDescription;
  List imageUrls;
  double price;

  @override
  State<Fooddescription> createState() => _FooddescriptionState();
}

class _FooddescriptionState extends State<Fooddescription> {
  int _currentImageIndex = 0;

  Future<void> createOrder() async {
    final String keyId = "";
    final String keySecret = "";

    final String url = "https://api.razorpay.com/v1/orders";

    final requestBody = {
      "amount": widget.price * 100,
      "currency": "INR",
      "transfers": [
        {
          "account": widget.account,
          "amount": ((widget.price * 100)*0.9).toString(),
          "currency": "INR",
          "notes": {"branch": "Royal Bakery", "name": "Senthil Nathan"},
          "linked_account_notes": ["branch"],
          "on_hold": 0,
        },
        {
          "account": "acc_PG7uLBTqV9HqN7",
          "amount": ((widget.price * 100)*0.1).toString(),
          "currency": "INR",
          "notes": {"branch": "Foodex Commission", "name": "Syed Abdullah"},
          "linked_account_notes": ["branch"],
          "on_hold": 0,
        }
      ]
    };


  

//Encoing the request body to JSON

    final String jsonBody = json.encode(requestBody);

// Make the HTTP POST request
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic " + base64Encode(utf8.encode("rzp_test_lzWR3duHRAxOv7:4taxttXylPHXU12PK3KwSApS")),
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        OrderResponse orderResponse = OrderResponse.fromJson(responseData);
        print("Order created successfully : ${response.body}");
       //open razorpay checkout
        _razorpay.open({
  'key': 'rzp_test_lzWR3duHRAxOv7',
  'amount': 3000, //in paise.
  'name': 'Testing',
  'order_id': orderResponse.id, // Generate order_id using Orders API
  'description': 'Food Ordering',
  'timeout': 120, // in seconds
  'prefill': {
    'contact': '9000090000',
    'email': 'gaurav.kumar@example.com'
  }
});
      } else {
        print("Failed to create order: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error creating order : $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);
      print("Payment Success: ${response.paymentId}, Order Id: ${response.orderId}");

    // print("Order created successfully");
    // final responseData = json.decode(response.body);
    // OrderResponse orderResponse = OrderResponse.fromJson(responseData);
    // print("Order ID : ${orderResponse.id}");
    // print("Order Amount: ${orderResponse.amount}");
    // print("Order Status: ${orderResponse.status}");
    // for (var transfer in orderResponse.transfers) {
    //   print("Transfer ID: ${transfer.id}, Recipient: ${transfer.recipient}, Amount: ${transfer.amount}, Notes: ${transfer.notes}");}
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
      print("Payment Error: ${response.code}, ${response.message}");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
      print("External Wallet: ${response.walletName}");

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                  items: widget.imageUrls.map<Widget>((imageUrl) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Back button
                Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Image indicators
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.imageUrls.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == entry.key ? Colors.white : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop name and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            widget.shopName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '₹${widget.price}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Shop address with icon
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 28),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${widget.shopAddress}, ${widget.area}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Shop number with icon
                    Row(
                      children: [
                        const Icon(Icons.store, color: Colors.grey, size: 28),
                        const SizedBox(width: 4),
                        Text(
                          'Shop ${widget.shopNumber}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description title
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description text
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.itemDescription,
                          style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 20),
                        ),
                      ),
                    ),

                    // Order Now button
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: createOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Order Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
