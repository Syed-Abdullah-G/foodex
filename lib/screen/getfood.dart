import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const _list = [
  "Adyar",
  "T Nagar",
  "Royapettah",
  "Anna Nagar",
  "Guindy",
  "Thousand Lights"
];
final db = FirebaseFirestore.instance;

class Getfood extends StatefulWidget {
  const Getfood({super.key});

  @override
  State<Getfood> createState() => _GetfoodState();
}

class _GetfoodState extends State<Getfood> {
  String? selectedArea;
  String shopnumber = "";
  String shopname = "";
  String address = "";
  String itemDescription = "";
  String dateofproduce = "";

  List restaurants= [];

  loadData(String area) async {
    final docRef =
        db.collection("area").doc(area);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          shopnumber = data["shopmobile"];
          shopname = data["shopname"];
          address = data["shopaddress"];
          itemDescription = data["itemDescription"];
           dateofproduce = data["dateofproduce"];
          
        });
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 10,),
            CustomDropdown.search(
                items: _list,
                hintText: "Select Area*",
                excludeSelected: false,
                onChanged: (value) {
                  setState(() {
                    loadData(value!);
                  });
                }), restaurants.isNotEmpty?
            SingleChildScrollView(
              child: ListView.builder(itemCount: restaurants.length,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    leading: Icon(Icons.restaurant),
                    title: Text(restaurants[index]),
                  );
      
                },
              ),
            ): Container(child: Text("Select an area to display the food items nearby"),),
          ],
        ),
      ),
    );
  }
}
