import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodex/models/userDetails.dart';
import 'package:foodex/userpage.dart';
import 'package:google_fonts/google_fonts.dart';

final db = FirebaseFirestore.instance;

class Getdetails extends StatefulWidget {
  const Getdetails({super.key});

  @override
  State<Getdetails> createState() => _HomeState();
}

class _HomeState extends State<Getdetails> {
  final namecontroller = TextEditingController();
  final mobilenumbercontroller = TextEditingController();
  final shopnamecontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  storeUserDetails(String name, String shopmobilenumber, String shopname, String address) async {
    final userdetails = Userdetails(name: name, shopmobilenumber: shopmobilenumber, shopname: shopname, address: address);
    Map<String, String> userMap = userdetails.toJson();
    await db.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).set(userMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ENTER DETAILS", style: GoogleFonts.bebasNeue(fontSize: 52)),
              const SizedBox(
                height: 40,
              ),

              _buildTextField(namecontroller, "Name", "Please enter your name"),

              const SizedBox(
                height: 10,
              ),
              _buildTextField(mobilenumbercontroller, "Shop Mobile Number", "Please enter a mobile number"),

              const SizedBox(
                height: 10,
              ),
              _buildTextField(shopnamecontroller, "Shop Name", "Please enter the shop name"),
              const SizedBox(
                height: 10,
              ),
              _buildTextField(addresscontroller, "Address", "Please enter the address"),

              const SizedBox(
                height: 30,
              ),

              // sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await storeUserDetails(namecontroller.text, mobilenumbercontroller.text, shopnamecontroller.text, addresscontroller.text);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                        }
                      },
                      child: const Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, String errorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return errorMessage;
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
