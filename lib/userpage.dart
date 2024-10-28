import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodex/event_details.dart';
import 'package:foodex/screen/getfood.dart';
import 'package:foodex/widgets/uploadfood.dart';

final db = FirebaseFirestore.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String shopnumber = "";
  String shopname = "";
  String address = "";
  int _currentIndex = 0;
  late PageController _pageController;

  loadData() {
    final docRef =
        db.collection("user").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data["name"] ?? "";
          shopnumber = data["shopnumber"] ?? "";
          shopname = data["shopname"] ?? "";
          address = data["address"] ?? "";
        });
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            Uploadfood(
                shopname: shopname,
                address: address,
                shopnumber: shopnumber,
                name: name),
            Getfood(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text('Create Event',style: TextStyle(color: Colors.black),), icon: Icon(Icons.home, color: const Color.fromARGB(248, 213, 108, 108),)),
            BottomNavyBarItem(title: Text('Food',style: TextStyle(color: Colors.black),), icon: Icon(Icons.food_bank,color: const Color.fromARGB(248, 213, 108, 108),)),
          ]),
    ));
  }
}
