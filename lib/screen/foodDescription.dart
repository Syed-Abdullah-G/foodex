import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodex/models/OrderResponse.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

    final String url = "https://api.razorpay.com/v1/orders";

    final requestBody = {
      "amount": widget.price * 100,
      "currency": "INR",
      "transfers": [
        {
          "account": widget.account,
          "amount": (widget.price * 100)*0.9,
          "currency": "INR",
          "notes": {"branch": "Royal Bakery", "name": "Senthil Nathan"},
          "linked_account_notes": ["branch"],
          "on_hold": 0,
        },
        {
          "account": "acc_PG7uLBTqV9HqN7",
          "amount": (widget.price * 100)*0.1,
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


  _makingPhoneCall(String number) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
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
        child: SingleChildScrollView(
          child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CarouselSlider(
                    options: CarouselOptions(enableInfiniteScroll: false,autoPlay: true,
                      height: 200,//carousel height should match the container height
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
                        child: CachedNetworkImage(imageUrl: imageUrl,fit: BoxFit.cover,),
                      );
                    }).toList(),
                  )
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Quantity Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Flexible(
                             child: AutoSizeText(
                                 "chicken biryani with egg and chilli chicken",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                                                       ),
                           ),
                           Container(
                             child: AutoSizeText(
                             widget.shopName,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),maxLines: 2,
                                                       ),
                           ),
                           Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ListTile(
                                dense: true,
                                leading: Icon(Icons.call),
                                title: AutoSizeText(widget.shopNumber,
                                style: GoogleFonts.poppins(fontSize: 16),maxLines: 1,
                                ),
                                trailing: TextButton(onPressed: () => _makingPhoneCall(widget.shopNumber), child: Text("Call"),),),),
                              
                            
                        ],
                      ),
                      // Quantity Counter
                     
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rating, Time and Calories
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          const Text(
                            '4.5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          const Text(
                            '8-10 min',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          const Text(
                            '124 Kcal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Nutritional Info
                  const Text(
                    'Protein-50gm, Carbs-10gm, Fats-15gm',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  const Text(
                    '(The unique recipe will make you fly in creaminess of cheeseburger)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Customize Button
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Customize',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.black),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Total Amount and Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            'Total amount',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\₹${widget.price.toString()}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD6F36A),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
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
