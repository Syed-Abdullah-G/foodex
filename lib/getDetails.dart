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

  storeUserDetails(String name, String shopmobilenumber, String shopname,
      String address) async {
    final userdetails = Userdetails(
        name: name,
        shopmobilenumber: shopmobilenumber,
        shopname: shopname,
        address: address);
    Map<String, String> userMap = userdetails.toJson();
    await db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(userMap);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter Details',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        _buildStyledTextField(
                          namecontroller,
                          'Enter your name',
                          'Please enter your name',
                        ),
                        const SizedBox(height: 16),
                        _buildStyledTextField(
                          mobilenumbercontroller,
                          'Enter shop mobile number',
                          'Please enter a mobile number',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildStyledTextField(
                          shopnamecontroller,
                          'Enter shop name',
                          'Please enter the shop name',
                        ),
                        const SizedBox(height: 16),
                        _buildStyledTextField(
                          addresscontroller,
                          'Enter address',
                          'Please enter the address',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await storeUserDetails(
                                namecontroller.text,
                                mobilenumbercontroller.text,
                                shopnamecontroller.text,
                                addresscontroller.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField(
    TextEditingController controller,
    String hintText,
    String errorMessage, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }
}