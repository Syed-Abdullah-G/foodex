// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// const _list = [
//   "Adyar",
//   "T Nagar",
//   "Royapettah",
//   "Anna Nagar",
//   "Guindy",
//   "Thousand Lights"
// ];
// final db = FirebaseFirestore.instance;



// void main() {
//   runApp(const TravelApp());
// }

// class TravelApp extends StatelessWidget {
//   const TravelApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         brightness: Brightness.dark,
//       ),
//       home:  TravelHomePage(),
//     );
//   }
// }

// class TravelHomePage extends StatefulWidget {
//    TravelHomePage({Key? key}) : super(key: key);

//   @override
//   State<TravelHomePage> createState() => _TravelHomePageState();
// }

// class _TravelHomePageState extends State<TravelHomePage> {
//     String? selectedArea;

//   String shopnumber = "";

//   String shopname = "";

//   String address = "";

//   String itemDescription = "";

//   String dateofproduce = "";

//   String imageUrl = "";

//    List restaurants = [];

//    loadData(String area) async {
//     print("function started");
//     restaurants.clear();
//     final docRef = await db.collection(area).get().then((querySnapshot) {
//       for (var docSnapshot in querySnapshot.docs) {
//         restaurants.add(docSnapshot.data());
//         print(docSnapshot.data());
        
//       }
//     });
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Search Bar
//             Container(
//               margin: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[800],
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: CustomDropdown.search(
//                 items: _list,
//                 hintText: "Select Area*",
//                 excludeSelected: false,
//                 onChanged: (value) async {
//                   await loadData(value!);
//                 }),
//             ),
            
//             // Grid of Places
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 padding: const EdgeInsets.all(16),
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 children:  [
//                   ListView.builder(itemCount: restaurants.length,itemBuilder: (context, index) {
//                     return PlaceCard(
//                     imageUrl: restaurants[index]["imageUrls"][0],
//                     placeName: restaurants[index]["shopname"][0],
//                     price: '\$254',
//                   );
//                   },)
//                 ],
//               ),
//             ),
            
//             // Bottom Navigation Bar
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlaceCard extends StatelessWidget {
//   final String imageUrl;
//   final String placeName;
//   final String price;

//   const PlaceCard({
//     Key? key,
//     required this.imageUrl,
//     required this.placeName,
//     required this.price,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.grey[900],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image
//           Expanded(
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey[800],
//                       child: const Icon(Icons.image, size: 50),
//                     );
//                   },
//                 ),
//                 // Price tag
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       price,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Bookmark icon
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.bookmark,
//                       color: Colors.red,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Place name
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               placeName,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:transparent_image/transparent_image.dart';

// const _list = [
//   "Adyar",
//   "T Nagar",
//   "Royapettah",
//   "Anna Nagar",
//   "Guindy",
//   "Thousand Lights"
// ];
// final db = FirebaseFirestore.instance;

// class Getfood extends StatefulWidget {
//   const Getfood({super.key});

//   @override
//   State<Getfood> createState() => _GetfoodState();
// }

// class _GetfoodState extends State<Getfood> {
//   String? selectedArea;
//   String shopnumber = "";
//   String shopname = "";
//   String address = "";
//   String itemDescription = "";
//   String dateofproduce = "";
//   String imageUrl = "";

//   List restaurants = [];

//   loadData(String area) async {
//     print("function started");
//     restaurants.clear();
//     final docRef = await db.collection(area).get().then((querySnapshot) {
//       for (var docSnapshot in querySnapshot.docs) {
//         restaurants.add(docSnapshot.data());
//         print(docSnapshot.data());
        
//       }
//     });
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             CustomDropdown.search(
//                 items: _list,
//                 hintText: "Select Area*",
//                 excludeSelected: false,
//                 onChanged: (value) async {
//                   await loadData(value!);
//                 }),
//             restaurants.isNotEmpty
//                 ? Expanded(
//                   child: ListView.builder(
//                       itemCount: restaurants.length,
//                       itemBuilder: (BuildContext context, index) {
//                         return FadeInImage.memoryNetwork(
//                           image: restaurants[index]["imageUrls"][0],
//                           placeholder: kTransparentImage,
//                         );
//                       },
//                     ),
//                 )
//                 : Container(
//                     child:
//                         Text("Select an area to display the food items nearby"),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
