import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
   Getfood({Key? key}) : super(key: key);

  @override
  State<Getfood> createState() => _GetfoodPageState();
}

class _GetfoodPageState extends State<Getfood> {
    String? selectedArea;

  String shopnumber = "";

  String shopname = "";

  String address = "";

  String itemDescription = "";

  String dateofproduce = "";

  String imageUrl = "";

   List restaurants = [];

   loadData(String area) async {
    print("function started");
    restaurants.clear();
    final docRef = await db.collection(area).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        restaurants.add(docSnapshot.data());
        print(docSnapshot.data());
        
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomDropdown.search(
                items: _list,
                hintText: "Select Area*",
                excludeSelected: false,
                onChanged: (value) async {
                  await loadData(value!);
                }),
            ),
            
            // Grid of Places
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                mainAxisSpacing: 16,crossAxisSpacing: 16),
                padding: const EdgeInsets.all(16),
                itemCount: restaurants.length,
                itemBuilder: (BuildContext context , index) {
                  return SquareImageCard(
                    imageUrl: restaurants[index]["imageUrls"][0],
                    shopName: restaurants[index]["shopname"],
                    price: 80,
                  );
                },
              
              ),
            ),
      
          ],
        ),
      ),
    );
  }
}
 class SquareImageCard extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final double price;

  const SquareImageCard({
    Key? key,
    required this.imageUrl,
    required this.shopName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1, // Ensures square aspect ratio
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}