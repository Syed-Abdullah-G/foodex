import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/api/razorpayApiCall2.dart';
import 'package:foodex/constants/area_names.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/models/userDetails.dart';
import 'package:foodex/screen/alreadyLogin.dart';
import 'package:foodex/screen/getShopDetails1.dart';
import 'package:foodex/screen/merchantNavigationscreen.dart';
import 'package:foodex/screen/userOrders.dart';
import 'package:foodex/widgets/textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

String valueSharedPreferences = "area";
String consumername = "consumername";
String consumermobile = "consumermobile";
String consumerarea = "consumerarea";
final db = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

class testingCreateAccount extends StatefulWidget {
  const testingCreateAccount({super.key});

  @override
  State<testingCreateAccount> createState() => _testingCreateAccountState();
}

class _testingCreateAccountState extends State<testingCreateAccount> {
  final contact_name = TextEditingController();
  final account_number = TextEditingController();
  final ifsc_code = TextEditingController();
  final beneficiary_name = TextEditingController();
  final mobilenumbercontroller = TextEditingController();
  final shopnamecontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final customermobilecontroller = TextEditingController();
  final customernamecontroller = TextEditingController();
  final customeraddresscontroller = TextEditingController();
  String area = "";
  bool isAreaSelected = false;
  String accountType = "shop";
  bool isShop = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String shopType = "";

  Future<void> storeShopDetails(String account, String shopmobilenumber, String shopname, String address, String area) async {
    setState(() => isLoading = true);
    try {
      print("entered shop function");
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "test123@gmail.com", password: "test123");

      final userdetails = Userdetails(account: account, shopmobilenumber: shopmobilenumber, shopname: shopname, address: address, area: area, accountType: accountType, uid: userid!, email: "test123@gmail.com");
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

  }

  Future saveUserData(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(valueSharedPreferences, value);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 52.h,
                ),
                Text(
                  "Sign Up to FoodEx",
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                    color: darkTextColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: lightTextColor,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const existingLogin(),
                          ));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: purpleColor,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  height: 10.h,
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
                getTextField2("Shop Name", shopnamecontroller),
                SizedBox(
                  height: 16.h,
                ),
                getTextField2("Phone Number", mobilenumbercontroller),
                SizedBox(
                  height: 16.h,
                ),
                getTextField2("Address", addresscontroller),
                SizedBox(
                  height: 16.h,
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
                          color: shopType == "bakeries" ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: shopType == "bakeries",
                      selectedColor: purpleColor,
                      onSelected: (bool selected) {
                        setState(() {
                          shopType = "bakeries";
                        });
                      },
                    ),
                  ],
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
                         
                           print("started");
                          final AccountID = await RazorpayHandler().initiateRazorpayProcess(email: "test123@gmail.com", phone: mobilenumbercontroller.text, businessName: shopnamecontroller.text, accountNumber: account_number.text, ifscCode: ifsc_code.text, beneficiaryName: beneficiary_name.text, contactName: beneficiary_name.text, area: area, subcategory: shopType, address: addresscontroller.text);
                          print(AccountID);
                          if (AccountID.isNotEmpty) {
                            await saveUserData(area);

                            await storeShopDetails(AccountID, mobilenumbercontroller.text, shopnamecontroller.text, addresscontroller.text, area);
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
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  height: 48.h,
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
