import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/getDetails.dart';
import 'package:foodex/bottomNavigationScreen.dart';
import 'package:foodex/models/consumerDetails.dart';
import 'package:foodex/models/userDetails.dart';
import 'package:foodex/screen/getfood.dart';
import 'package:foodex/widgets/consumerNavigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

String valueSharedPreferences = "area";
String consumername = "consumername";
String consumermobile = "consumermobile";
String consumerarea = "consumerarea";

final db = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobilenumbercontroller = TextEditingController();
  final shopnamecontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final customermobilecontroller = TextEditingController();
  final customernamecontroller = TextEditingController();
  final customeraddresscontroller = TextEditingController();
  String area = "";
  bool isAreaSelected = false;
  String accountType = "";
  bool isShop = false;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  if (snapshot.exists) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationScreen()));
  }
  else {

       final userdetails = Userdetails(account: account, shopmobilenumber: shopmobilenumber, shopname: shopname, address: address, area: area, accountType: accountType, uid: userid!, email: FirebaseAuth.instance.currentUser!.email!);
    Map<String, String> userMap = userdetails.toJson();
    await db.collection("user").doc(userid).set(userMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationScreen()));
  }
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

  Future saveConsumerData(String name, String mobileno, String area) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(consumername, name);
    await sharedPreferences.setString(consumermobile, mobileno);
    await sharedPreferences.setString(consumerarea, area);
  }

  storeConsumerDetails(String name, String mobile, String area) async {
    setState(() {
      isLoading = true;
    });
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
final userid =  FirebaseAuth.instance.currentUser!.email;

  DocumentReference accountExists = FirebaseFirestore.instance.collection("consumer").doc(userid);
  


  DocumentSnapshot snapshot = await accountExists.get();

  if (snapshot.exists) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const consumerNavigationScreen()));
    return;
  }
  else {
         final userdetails = Consumerdetails(name: name, mobile: mobile, area: area, uid: userid!, email: FirebaseAuth.instance.currentUser!.email!, orders: "");
    Map<String, String> userMap = userdetails.toJson();
    await db.collection("consumer").doc(userid).set(userMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const consumerNavigationScreen()));
  }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: ${e.toString()}')),
        );
      }
    }
    
return "";
   
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mobilenumbercontroller.dispose();
    shopnamecontroller.dispose();
    addresscontroller.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool isLoading = false;

  Widget getTextField(String hint, String hint2, TextEditingController shopcontroller, TextEditingController customercontroller, bool isShop) {
    return TextField(
      controller: isShop ? shopcontroller : customercontroller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          filled: true,
          fillColor: textFieldColor,
          hintText: isShop ? hint : hint2,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          )),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 52.h,
              ),
              Text(
                "Sign Up to FoodEx",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: darkTextColor,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Wrap(
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: lightTextColor,
                    ),
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: purpleColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: Text(
                      'Customer',
                      style: TextStyle(
                        color: accountType == "customer" ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: accountType == "customer",
                    selectedColor: purpleColor,
                    onSelected: (bool selected) {
                      setState(() {
                        accountType = "customer";
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text(
                      'Shop',
                      style: TextStyle(
                        color: accountType == "shop" ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: accountType == "shop",
                    selectedColor: purpleColor,
                    onSelected: (bool selected) {
                      setState(() {
                        accountType = "shop";
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              getTextField("Shop Name", "Full Name", shopnamecontroller, customernamecontroller, accountType == "shop"),
              SizedBox(
                height: 16.h,
              ),
              getTextField("Phone Number", "Mobile Number", mobilenumbercontroller, customermobilecontroller, accountType == "shop"),
              SizedBox(
                height: 16.h,
              ),
              getTextField("Address", "Address", addresscontroller, customeraddresscontroller, accountType == "shop"),
              SizedBox(
                height: 16.h,
              ),
              CustomDropdown.search(
                  decoration: CustomDropdownDecoration(
                      closedFillColor: textFieldColor,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      )),
                  items: Area_list,
                  hintText: "Select Area*",
                  excludeSelected: false,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        area = value;
                        isAreaSelected = true;
                      });
                    }
                  }),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final razorpay_id = "acc_PGXA5GFiAwFfLD";

                    if (accountType == "customer") {
                      if (!isAreaSelected || customernamecontroller.text.isEmpty || customeraddresscontroller.text.isEmpty || customermobilecontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all the details')),
                        );
                      } else {
                        // final String googleID = await signInWithGoogle();
                        await saveUserData(area);
                        await saveConsumerData(customernamecontroller.text, customermobilecontroller.text, area);
                       storeConsumerDetails(customernamecontroller.text, customermobilecontroller.text, area);
                      
                      }
                    } else if (accountType == "shop") {
                      if (!isAreaSelected || shopnamecontroller.text.isEmpty || mobilenumbercontroller.text.isEmpty || addresscontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all the details')),
                        );
                      } else {
                        await saveUserData(area);
                       await storeShopDetails(razorpay_id, mobilenumbercontroller.text, shopnamecontroller.text, addresscontroller.text, area);
                      }
                    } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Select Customer or Shop")),
                        );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h)),
                      textStyle: MaterialStateProperty.all(TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Image.asset("assets/userPhoto/google_logo.png"),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text("Create Account")
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 48.h,
              ),
              Wrap(
                children: [
                  Text(
                    "By signing up to Masterminds you agree to our ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: lightTextColor,
                    ),
                  ),
                  Text(
                    "terms and conditions",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: purpleColor,
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
