
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/screen/foodDescription.dart';

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
  String uid = "";
  Future<dynamic>? dataFuture;




  Future<void> loadUserData() async {
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
    print("User  logged out");
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dataFuture = getUserData();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,resizeToAvoidBottomInset: true,
      
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
         
          consumerCard(consumerName: name, consumerMobile: mobile, consumerArea: area),
          SizedBox(height: 10.h,),
          CustomDropdown.search(
              decoration: CustomDropdownDecoration(closedFillColor: Colors.black,headerStyle: TextStyle(color: Colors.white, fontSize: 15.sp),expandedFillColor: Colors.blueGrey[50], hintStyle: const TextStyle(color: Colors.white),prefixIcon: const Icon(Icons.location_on_outlined,color: Colors.white,)),
              items: Area_list,
              hintText: "Select Area*",
              excludeSelected: false,
              onChanged: (value) {
                if (value != null) {
                  loadData(value);
                }
              }),SizedBox(height: 10.h,),
          _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : restaurants.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: restaurants[0]["fooditems"].where((foodItem) {
                          // Ensure quantity is a number and greater than 0
                          return foodItem["quantity"] != null && (foodItem["quantity"] is int || foodItem["quantity"] is double) && foodItem["quantity"] > 0;
                        }).length,
                        itemBuilder: (BuildContext context, index) {
                          var foodItems = restaurants[0]["fooditems"].where((foodItem) {
                            return foodItem["quantity"] != null && (foodItem["quantity"] is int || foodItem["quantity"] is double) && foodItem["quantity"] > 0;
                          }).toList();
                          if (index < foodItems.length) {
                            var foodItem = foodItems[index];
                            var imageFileURL = foodItem["imageFileURL"];

                            var consumerName = foodItem["shopname"];
                            var shopNumber = foodItem["shopmobile"];
                            var shopAddress = foodItem["shopaddress"];
                            var account = foodItem["account"];
                            var itemDescription = foodItem["itemDescription"];
                            var dateofproduce = foodItem["dateofproduce"];
                            var quantity = foodItem["quantity"];
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
                                                shopName: consumerName,
                                                shopAddress: shopAddress,
                                                itemDescription: itemDescription,
                                                imageUrl: imageFileURL,
                                                account: account,
                                                quantity: quantity,
                                                userid: userid,
                                                shopprice: shopprice, shopuid: userid
                                              )));
                                },
                                child: _foodwidget(imageURL: imageFileURL, title: itemDescription, price: shopprice.toString()));
                          }
                          return null;
                        },
                      ),
                    )
                  : const SizedBox()
        ],
      ),
    ));
  }
}

class _foodwidget extends StatelessWidget {
  final String imageURL;
  final String title;
  final String price;

  const _foodwidget({
    required this.imageURL,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Metropolis",
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$$price',
                    style: TextStyle(fontFamily: "Metropolis", fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.green[800]),
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


class consumerCard extends StatelessWidget {
  final String consumerName;
  final String consumerMobile;
  final String consumerArea;

  const consumerCard({super.key, 
    required this.consumerName,
    required this.consumerMobile,
    required this.consumerArea,
  });

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 93, 139, 234), Color(0xFF755EE8), Colors.purpleAccent,Colors.amber,],
          ),
    ),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: Colors.white,
        margin: EdgeInsets.all(3.0.r),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                consumerName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.black54),
                  const SizedBox(width: 8.0),
                  Text(
                    consumerMobile,
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
                    consumerArea,
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
      ),
    );
  }
}
