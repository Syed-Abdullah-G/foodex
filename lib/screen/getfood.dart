import 'dart:ffi';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/getDetails.dart';
import 'package:foodex/login.dart';
import 'package:foodex/screen/foodDescription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

final db = FirebaseFirestore.instance;
 final userid = FirebaseAuth.instance.currentUser!.email;

class Getfood extends StatefulWidget {
  const Getfood({super.key});

  @override
  State<Getfood> createState() => _GetfoodPageState();
}

class _GetfoodPageState extends State<Getfood> {
  String selectedArea = "";
  List restaurants = [];
  bool _loading = false;
  String name = "";
  String mobile = "";
  String area = "";
  String email = "";
  String uid ="";
  Future<dynamic>? dataFuture;

    Future<void> loadUserData() async{
    final docRef = db.collection("consumer").doc(userid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'];
          mobile = data['shopnumber'];
          area = data['area'];
          email = data['email'];
          uid = data['uid'];

         

        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

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

  // Future getUserData() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     consumerName = toTitleCase(sharedPreferences.getString("consumername")!);
  //     consumerMobile = sharedPreferences.getString("consumermobile")!;
  //     consumerArea = sharedPreferences.getString("consumerarea")!;
  //     _loading = false;
  //   });
  // }

  // String toTitleCase(String text) {
  //   return text.split(' ').map((word) {
  //     if (word.isEmpty) return '';
  //     return word[0].toUpperCase() + word.substring(1).toLowerCase();
  //   }).join(' ');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dataFuture = getUserData();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   Padding(
        padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${name}',
              style: GoogleFonts.montserrat(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 1.h,
            ),
            Text('Craving for Biryani ?', style: GoogleFonts.inter(fontSize: 20.sp, color: Color.fromRGBO(136, 136, 136, 100))),
            SizedBox(height: 16),
            CustomDropdown.search(
                decoration: CustomDropdownDecoration(closedFillColor: Colors.blue[600], expandedFillColor: Colors.white, hintStyle: TextStyle(color: Colors.white)),
                items: Area_list,
                hintText: "Select Area*",
                excludeSelected: false,
                onChanged: (value) {
                  if (value != null) {
                    loadData(value);
                  }
                }),
            SizedBox(height: 16),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : restaurants.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10,);
                        },
                          itemCount: restaurants[0]["fooditems"].where((foodItem) => foodItem["quantity"] > 0).length,
                          itemBuilder: (BuildContext context, index) {
                            var foodItems = restaurants[0]["fooditems"].where((foodItem) => foodItem["quantity"] > 0).toList();

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
                              var quantity = foodItem["quantity"] ;
                              var userid = foodItem["userid"];
                              var shopprice = foodItem["shopprice"];
      
                              return GestureDetector(
                                  onTap: () {
                                    print(userid);
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
                                                  userid: userid,
                                                  shopprice: shopprice,
                                                )));
                                  },
                                  child: _foodwidget(imageURL: imageFileURL, title: itemDescription, price: price.toString()));  

                            }
                            return null;
                          },
                        ),
                      )
                    : SizedBox()
          ],
        ),
      ) 
    );
  }
}

class _foodwidget extends StatelessWidget {
  final String imageURL;
  final String title;
  final String price;

  _foodwidget({
    required this.imageURL,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(30),

      child: Card(
        elevation: 4.0,
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageURL,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Metropolis",
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '\$${price}',
                    style: TextStyle(fontFamily: "Metropolis",
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800]
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
