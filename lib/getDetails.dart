// import 'dart:io';

// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_launcher_icons/main.dart';
// import 'package:flutter_launcher_icons/xml_templates.dart';
// import 'package:foodex/constants/area_names.dart';
// import 'package:foodex/models/consumerDetails.dart';
// import 'package:foodex/models/userDetails.dart';
// import 'package:foodex/bottomNavigationScreen.dart';
// import 'package:foodex/screen/getfood.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// String valueSharedPreferences = "area";
// String consumername  = "consumername";
// String consumermobile = "consumermobile";
// String consumerarea = "consumerarea";

// final db = FirebaseFirestore.instance;
// final storageRef = FirebaseStorage.instance.ref();

// class Getdetails extends StatefulWidget {
//   const Getdetails({super.key});

//   @override
//   State<Getdetails> createState() => _HomeState();
// }

// class _HomeState extends State<Getdetails> {
//   final mobilenumbercontroller = TextEditingController();
//   final shopnamecontroller = TextEditingController();
//   final addresscontroller = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String area = "";
//   String accountType = "";
//   bool isAreaSelected = false;
//   final userUID = FirebaseAuth.instance.currentUser!.uid;

//   bool isLoading = false;

//   storeUserDetails(String account, String shopmobilenumber, String shopname, String address, String area, String UID) async {
//     setState(() {
//       isLoading = true;
//     });

//     final userdetails = Userdetails(account: account, shopmobilenumber: shopmobilenumber, shopname: shopname, address: address, area: area, accountType: accountType, uid: UID);
//     Map<String, String> userMap = userdetails.toJson();
//     await db.collection("user").doc(userUID).set(userMap);
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationScreen()));
//   }



//   storeConsumerDetails(String name, String mobile, String area, String UID) async {
//     setState(() {
//       isLoading = true;
//     });

//     final userdetails = Consumerdetails(name: name, uid: UID, mobile: mobile, area: area);
//     Map<String, String> userMap = userdetails.toJson();
//     await db.collection("consumer").doc(UID).set(userMap);
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const Getfood()));
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     mobilenumbercontroller.dispose();
//     shopnamecontroller.dispose();
//     addresscontroller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text(
//                           'Enter Details',
//                           style: GoogleFonts.poppins(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 32),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Select Account Type',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ChoiceChip(
//                               label: Text(
//                                 'Shop',
//                                 style: TextStyle(
//                                   color: accountType == "shop" ? Colors.white : Colors.black87,
//                                 ),
//                               ),
//                               selected: accountType == "shop",
//                               selectedColor: Colors.blueAccent,
//                               onSelected: (bool selected) {
//                                 setState(() {
//                                   accountType = "shop";
//                                 });
//                               },
//                             ),
//                             ChoiceChip(
//                               label: Text(
//                                 'Customer',
//                                 style: TextStyle(
//                                   color: accountType == "customer" ? Colors.white : Colors.black87,
//                                 ),
//                               ),
//                               selected: accountType == "customer",
//                               selectedColor: Colors.blueAccent,
//                               onSelected: (bool selected) {
//                                 setState(() {
//                                   accountType = "customer";
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         _buildStyledTextField(
//                           shopnamecontroller,
//                           'Shop Name',
//                           "Name",
//                           accountType == "shop",
//                           'Please enter the shop name',
//                         ),
//                         const SizedBox(height: 16),
//                         _buildStyledTextField(
//                           mobilenumbercontroller,
//                           'Shop Mobile Number',
//                           "Mobile Number",
//                           accountType == "shop",
//                           'Please enter a mobile number',
//                           keyboardType: TextInputType.phone,
//                         ),
//                         const SizedBox(height: 16),
//                         accountType == "shop"
//                             ? _buildStyledTextField(
//                                 addresscontroller,
//                                 'Enter address',
//                                 "",
//                                 accountType == "shop",
//                                 'Please enter the address',
//                                 maxLines: 2,
//                               )
//                             : const SizedBox(),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         CustomDropdown.search(
//                             items: Area_list,
//                             hintText: "Select Area*",
//                             excludeSelected: false,
//                             onChanged: (value) {
//                               if (value != null) {
//                                 setState(() {
//                                   area = value;
//                                   isAreaSelected = true;
//                                 });
//                               }
//                             }),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 32,
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             final razorpay_id = "acc_PGXA5GFiAwFfLD";

//                             if (_formKey.currentState!.validate() && isAreaSelected) {
//                               saveUserData(area);
//                               saveConsumerData(shopnamecontroller.text, mobilenumbercontroller.text, area);
//                               accountType == "shop" ? await storeUserDetails(razorpay_id, mobilenumbercontroller.text, shopnamecontroller.text, addresscontroller.text, area, userUID) : storeConsumerDetails(shopnamecontroller.text, mobilenumbercontroller.text, area, userUID);
//                             } else if (!isAreaSelected) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Please select an area')),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFDBF666),
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   'Submit',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStyledTextField(
//     TextEditingController controller,
//     String hintText1,
//     String hintText2,
//     bool isShop,
//     String errorMessage, {
//     TextInputType? keyboardType,
//     maxLines,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         hintText: isShop ? hintText1 : hintText2,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         filled: true,
//         fillColor: const Color.fromARGB(255, 255, 255, 255),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return errorMessage;
//         }
//         return null;
//       },
//     );
//   }
// }
