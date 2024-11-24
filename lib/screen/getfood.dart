import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/screen/foodDescription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

final db = FirebaseFirestore.instance;

class Getfood extends StatefulWidget {
  const Getfood({super.key});

  @override
  State<Getfood> createState() => _GetfoodPageState();
}

class _GetfoodPageState extends State<Getfood> {
  String selectedArea = "";
  List restaurants = [];
  bool _loading = true;

  Future<void> loadData(String area) async {
    print("function started");
    setState(() {
      selectedArea = area;
      _loading = true;
    });
    try {
      restaurants.clear();
      final querySnapshot = await db.collection(area).get();

      setState(() {
        for (var docSnapshot in querySnapshot.docs) {
          restaurants.add(docSnapshot.data());
          print(docSnapshot.data());
        }
        _loading = false; // Set loading to false after data is loaded
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomDropdown.search(
                  items: Area_list,
                  hintText: "Select Area*",
                  excludeSelected: false,
                  onChanged: (value) {
                    if (value != null) {
                      loadData(value);
                    }
                  }),
            ),
            _loading
                ? Center(
                    child: Text("Please Select Area", style: GoogleFonts.poppins(fontSize: 20),),
                  )
                // Grid of Places
                : restaurants.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: restaurants[0]["fooditems"].length,
                          itemBuilder: (BuildContext context, index) {
                            var foodItems = restaurants[0]["fooditems"];

                            if (index < foodItems.length) {
                              var foodItem = foodItems[index];
                              var imageFileURL = foodItem["imageFileURL"];
            
                              var shopName = foodItem["shopname"];
                              var shopNumber = foodItem["shopmobile"];
                              var shopAddress = foodItem["shopaddress"];
                              var account = foodItem["account"];
                              var itemDescription = foodItem["itemDescription"];
                              var dateofproduce = foodItem["dateofproduce"];
                              var price = foodItem["price"] ?? 0;
                              var quantity = foodItem["quantity"] ?? 0;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetailCard(
                                                area: selectedArea,
                                                shopNumber: shopNumber,
                                                shopName: shopName,
                                                shopAddress: shopAddress,
                                                itemDescription: itemDescription,
                                                imageUrl: imageFileURL,
                                                price: price,
                                                account: account,
                                                quantity: quantity,
                                              )));
                                },
                                child: SquareImageCard(
                                  imageUrl: imageFileURL,
                                  shopName: shopName,
                                  price: price,
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      )
                    : SizedBox()
          ],
        ),
      ),
    );
  }
}

class SquareImageCard extends StatefulWidget {
  final String imageUrl;
  final String shopName;
  final int price;

  const SquareImageCard({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.price,
  });

  @override
  State<SquareImageCard> createState() => _SquareImageCardState();
}

class _SquareImageCardState extends State<SquareImageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Center(
                  child: CachedNetworkImage(imageUrl: widget.imageUrl),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shopName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${widget.price.toString()}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
