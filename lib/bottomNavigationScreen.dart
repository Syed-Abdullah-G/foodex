import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodex/event_details.dart';
import 'package:foodex/screen/getfood.dart';
import 'package:foodex/widgets/HomeScreen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

final db = FirebaseFirestore.instance;

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  String account = "";
  String shopnumber = "";
  String shopname = "";
  String address = "";
  String profileImage = "";
  int selected = 0;
  late PageController _pageController;
  final controller = PageController();

  loadData() {
    final docRef = db.collection("user").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          account = data["account"] ?? "";
          shopnumber = data["shopnumber"] ?? "";
          shopname = data["shopname"] ?? "";
          address = data["address"] ?? "";
          profileImage = data["profileImage"] ?? "";
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
        child: Scaffold(extendBody: true,
        resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: PageView(
        controller: controller,
        children: [
          HomeScreen(
            shopname: shopname,
            address: address,
            shopnumber: shopnumber,
            account: account,
            profileImage: profileImage,
          ),
          const Getfood(),
        ],
      )),
      bottomNavigationBar: StylishBottomBar(
          items: [
            BottomBarItem(
              icon: Icon(Icons.delivery_dining_outlined),
              title: Text("Order"),
              selectedIcon: Icon(Icons.delivery_dining_rounded),
            ),
            BottomBarItem(icon: Icon(Icons.food_bank_outlined), title: Text("Food"), selectedIcon: Icon(Icons.food_bank_rounded))
          ],
          fabLocation: StylishBarFabLocation.end,
        
          currentIndex: selected,
          onTap: (index) {

            if (index == selected) return;
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          },
         
          option: AnimatedBarOptions(
            iconSize: 32,
            barAnimation: BarAnimation.blink,
            iconStyle: IconStyle.Default,
            opacity: 0.3,
          )),
    ));
  }
}
