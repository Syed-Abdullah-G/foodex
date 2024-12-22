import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodex/event_details.dart';
import 'package:foodex/screen/getfood.dart';
import 'package:foodex/widgets/HomeScreen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

final db = FirebaseFirestore.instance;

class MerchantNavigationScreen extends StatefulWidget {
  const MerchantNavigationScreen({super.key});

  @override
  State<MerchantNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<MerchantNavigationScreen> {
  String account = "";
  String shopnumber = "";
  String shopname = "";
  String address = "";
  String accountType = "";
  String userid = "";


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
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(extendBody: true,
        resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: HomeScreen(
        shopname: shopname,
        address: address,
        shopnumber: shopnumber,
        account: account, accountType: accountType,userid: userid,
      ),
      
    ));
  }
}