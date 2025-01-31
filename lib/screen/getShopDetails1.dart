import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/api/razorpayApiCall2.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/login.dart';
import 'package:foodex/models/userDetails.dart';
import 'package:foodex/screen/merchantNavigationscreen.dart';
import 'package:foodex/screen/userOrders.dart';
import 'package:foodex/widgets/textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final db = FirebaseFirestore.instance;

class GetShopDetails1 extends StatefulWidget {
  GetShopDetails1({super.key, required this.phone, required this.shopname, required this.area, required this.address});

  String phone;
  String shopname;
  String area;
  String address;

  @override
  State<GetShopDetails1> createState() => _GetShopDetails1State();
}

class _GetShopDetails1State extends State<GetShopDetails1> {
  final contact_name = TextEditingController();
  final account_number = TextEditingController();
  final ifsc_code = TextEditingController();
  final beneficiary_name = TextEditingController();
  String subcategory = "";
  String shopType = "";
  bool isLoading = false;
  final email = FirebaseAuth.instance.currentUser!.email;

  Future<String> storeShopDetails(String account, String shopmobilenumber, String shopname, String address, String area) async {
    setState(() => isLoading = true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return "";
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final userid = FirebaseAuth.instance.currentUser!.email;

      DocumentReference accountExists = FirebaseFirestore.instance.collection("user").doc(userid);

      DocumentSnapshot snapshot = await accountExists.get();

      final userdetails = Userdetails(account: account, shopmobilenumber: shopmobilenumber, shopname: shopname, address: address, area: area, accountType: "shop", uid: userid!, email: FirebaseAuth.instance.currentUser!.email!);
      Map<String, String> userMap = userdetails.toJson();
      await db.collection("user").doc(userid).set(userMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MerchantNavigationScreen()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: ${e.toString()}')),
        );
      }
    }

    return "";
  }

  Future saveUserData(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(valueSharedPreferences, value);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contact_name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Text(
                  "Choose Business Type",
                  style: GoogleFonts.poppins(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'Restaurant',
                        style: TextStyle(
                          color: shopType == "restaurant" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "restaurant",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "restaurant";
                        });
                      },
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'Dairy Products',
                        style: TextStyle(
                          color: shopType == "dairy_products" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "dairy_products",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "dairy_products";
                        });
                      },
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'Bakery',
                        style: TextStyle(
                          color: shopType == "bakery" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "bakery",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "bakery";
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Bank Details",
                  style: GoogleFonts.poppins(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                getTextField2("Account Number", account_number),
                SizedBox(
                  height: 16.h,
                ),
                getTextField2("IFSC Code", ifsc_code),
                SizedBox(
                  height: 16.h,
                ),
                getTextField2("Beneficiary Name", beneficiary_name),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      if (shopType.isEmpty || account_number.text.isEmpty || ifsc_code.text.isEmpty || beneficiary_name.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all the details')),
                        );
                      } else {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator()),
                          );

                          final AccountID = await RazorpayHandler().initiateRazorpayProcess(email: email!, phone: widget.phone, businessName: widget.shopname, accountNumber: account_number.text, ifscCode: ifsc_code.text, beneficiaryName: beneficiary_name.text, contactName: beneficiary_name.text, area: widget.area, subcategory: shopType, address: widget.address);
                          if (AccountID.isNotEmpty) {
                            await saveUserData(widget.area);

                            storeShopDetails(AccountID, widget.phone, widget.shopname, widget.address, widget.area);
                          }
                        } catch (e) {}
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(purpleColor),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: WidgetStateProperty.all(TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Image.asset("assets/userPhoto/google_logo.png"),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Text("Create Account")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
