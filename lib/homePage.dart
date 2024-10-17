import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

Future _fetchUserData() async{
       final docRef = db.collection("user").doc(FirebaseAuth.instance.currentUser!.phoneNumber);
    final DocumentSnapshot doc = await docRef.get();
        return doc.data() as Map<String, dynamic>;
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: FutureBuilder(future: _fetchUserData(), builder: 
    (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(),);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"),);
      } else if (snapshot.hasData) {
        final userData = snapshot.data!;
        return Center(child: Text(userData["name"]),);
      } else {
        return Center(child: Text("No data found.."),);
      }
    },),
    );
  }
}