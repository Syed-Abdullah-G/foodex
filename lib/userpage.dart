import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodex/event_details.dart';

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



loadData() {
  final docRef = db.collection("user").doc(FirebaseAuth.instance.currentUser!.uid);
docRef.get().then(
  (DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
     name  = data["name"];
     shopnumber  = data["shopnumber"];
     shopname  = data["shopname"];
     address  = data["address"];


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
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddExpenseScreen()));

        },
        child: Icon(Icons.add),),
      
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(

              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/userPhoto/A2B.jpg'), // Add your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
               Text(
              shopname,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
               Text(
                address,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                shopnumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}