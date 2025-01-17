import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/event_details.dart';
import 'package:foodex/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final db = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _UploadfoodState();
}

class _UploadfoodState extends State<HomeScreen> {
  String account = "";
  String shopnumber = "";
  String shopname = "";
  String address = "";
  String accountType = "";
  String userid = "";
  int visit = 0;
  String areaName = "";
  List orders = [];
  List completedOrders = [];
  List uncompletedOrders = [];
  bool isLoading = true;
  bool showCompletedOrders = false;
  Future<List>? dataFuture;
  String selectedOption = "completed";


loadData() {
    final docRef = db.collection("user").doc(FirebaseAuth.instance.currentUser!.email);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          account = data["account"] ?? "";
          shopnumber = data["shopnumber"] ?? "";
          shopname = data["shopname"] ?? "";
          address = data["address"] ?? "";
          accountType = data["accountType"] ?? "";
          userid = data["uid"] ?? "";
          areaName = data["area"] ?? "";

        });
      
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }




  Future<List> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      areaName = sharedPreferences.getString("area") ?? "";
    });
    try {
    final restaurant = await db.collection(areaName).doc(userid).get();
    final foodItemsSet = restaurant["fooditems"];
    setState(() {
      orders = foodItemsSet.toList();
      _updateOrderLists();
  
      isLoading = false;
    });
    return orders;} catch (e) {
      return [];
    }
    // [{dateofproduce: 2024-11-30, quantity: 3, price: 40, shopname: Fresh N Tasty, shopaddress: Avadi, Chennai., shopmobile: 7200054975, imageFileURL: https://firebasestorage.googleapis.com/v0/b/food-f88e3.appspot.com/o/Avadi%2FFresh%20N%20Tasty%2Fdata%2Fuser%2F0%2Fcom.testing.foodex%2Fcache%2F4c1091b3-c1ed-4c0b-9b6d-a57ecd53ce28%2F25.jpg.png?alt=media&token=bcaeab85-0a69-4dcc-9eca-99293c9cbe63, itemDescription: butter chicken, account: 5P8xfM4pr7hxV26O37iK5ZYMDM62}, {dateofproduce: 2024-11-30, quantity: 2, price: 20, shopname: Fresh N Tasty, shopaddress: Avadi, Chennai., shopmobile: 7200054975, imageFileURL: https://firebasestorage.googleapis.com/v0/b/food-f88e3.appspot.com/o/Avadi%2FFresh%20N%20Tasty%2Fdata%2Fuser%2F0%2Fcom.testing.foodex%2Fcache%2F4b5e5623-89e0-482b-8955-4d16074042db%2F20.jpg.png?alt=media&token=95f021f0-492e-4848-883e-a1047dabb881, itemDescription: biryani, account: 5P8xfM4pr7hxV26O37iK5ZYMDM62}]
  }

  void _updateOrderLists() {
     if (selectedOption == "completed") {
      completedOrders = orders.where((item) => item["quantity"] == 0).toList();
    } else {
      completedOrders = orders.where((item) => item["quantity"] != 0).toList();
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your log out functionality here
                _logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    // Implement your log out logic here
    // For example, clear user data, navigate to login screen, etc.
    await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));

  }


  void _deleteFoodItem(Map<String, dynamic> itemToDelete) async {
  try {
    // Remove the specific item from the fooditems array
    await db.collection(areaName).doc(userid).update({
      'fooditems': FieldValue.arrayRemove([itemToDelete])
    });

    // Update the local state
    setState(() {
      // Remove the item from the orders list
      orders.removeWhere((item) => 
        item['itemDescription'] == itemToDelete['itemDescription'] &&
        item['dateofproduce'] == itemToDelete['dateofproduce'] &&
        item['shopprice'] == itemToDelete['shopprice']
      );

      // Refresh the order lists
      _updateOrderLists();
    });

    // Optional: Show a snackbar to confirm deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted successfully')),
    );
  } catch (e) {
    
    // Optional: Show an error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to delete item')),
    );
  }
}

















  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFuture = getUserData();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
         
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => event_details(
                shopname:shopname,
                account: account,
                shopnumber:shopnumber,
                address: address,
                userid: userid,
              ),
            ));
          },
          backgroundColor: purpleColor,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.blue[700],
        body: SafeArea(
          child: Column(children: [
           
            ShopCard(shopName: shopname, shopAddress: address, shopMobileNumber:shopnumber, shopArea: areaName),
            Container(
              color: Colors.blue[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CategoryButton(
                        text: 'Completed',
                        isSelected: selectedOption == "completed",
                        onPressed: () {
                          setState(() {
                            selectedOption = "completed";
                            _updateOrderLists();
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CategoryButton(
                        text: 'Pending',
                        isSelected: selectedOption == "pending",
                        onPressed: () {
                          setState(() {
                            selectedOption = "pending";
                            _updateOrderLists();
                  
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}')); // Show error message
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No items found.')); // Show no items message
                      } else {
                        return Container(
                            padding:  EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                            decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.r),
                                topRight: Radius.circular(32.r),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await getUserData();
                                    },
                                    child: CustomScrollView(
                                      key: const PageStorageKey<String>('food-items-scroll'),
                                      slivers: [
                                        SliverPadding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          sliver: SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                                final item = completedOrders[index];
                                                final dateofproduce = item["dateofproduce"];
                                                final quantity = item["quantity"];
          
                                                final price = item["shopprice"];
                                                final shopname = item["shopname"];
          
                                                final shopaddress = item["shopaddress"];
                                                final shopmobile = item["shopmobile"];
                                                final imageFileURL = item["imageFileURL"];
                                                final itemDesc = item["itemDescription"];
                                                final account = item["account"];
          
                                                return FoodItemCard(
                                                  imageUrl: imageFileURL,
                                                  itemName: itemDesc,
                                                  dateOfProduce: dateofproduce,
                                                  quantity: quantity,
                                                  price: price,
                                                  onDelete: () => _deleteFoodItem(item),
                                                );
                                              },
                                              childCount: completedOrders.length,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      }
                    }))
          ]),
        ));
  }
}

class _CategoryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const _CategoryButton({required this.text, required this.onPressed, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      shadowColor: Colors.black54,
      width: 150,
      height: 30,
      backgroundColor: isSelected ? Colors.grey[500] : Colors.white,
      isThreeD: true,
      borderRadius: 25,
      animate: true,
      margin: const EdgeInsets.all(10),
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  final String shopName;
  final String shopAddress;
  final String shopMobileNumber;
  final String shopArea;

  const ShopCard({super.key, 
    required this.shopName,
    required this.shopAddress,
    required this.shopMobileNumber,
    required this.shopArea,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white,
      margin: EdgeInsets.all(7.0.r),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shopName,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black54),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    shopAddress,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(
                  shopMobileNumber,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.map, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(
                  shopArea,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imageUrl;
  final String itemName;
  final String dateOfProduce;
  final int quantity;
  final int price;
  final VoidCallback onDelete;

  const FoodItemCard({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.dateOfProduce,
    required this.quantity,
    required this.price,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children:[ Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cached Network Image for efficient image loading
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.food_bank),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: $dateOfProduce',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Qty: $quantity',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Price: ₹$price',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), 
        Align(
          alignment: Alignment.topRight,
          child: Padding(padding: const EdgeInsets.all(0),
          child: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: Colors.red,)),),
        )]
      ),
    );
  }
}
