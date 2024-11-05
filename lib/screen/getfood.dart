import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodex/screen/foodDescription.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:transparent_image/transparent_image.dart';
List<String> _list = [
"Adambakkam",
"Adyar",
"Alandur",
"Alapakkam",
"Alwarpet",
"Alwarthirunagar",
"Ambattur",
"Aminjikarai",
"Anna Nagar",
"Annanur",
"Arumbakkam",
"Ashok Nagar",
"Avadi",
"Ayanavaram",
"Beemannapettai",
"Besant Nagar",
"Basin Bridge",
"Chepauk",
"Chetput",
"Chintadripet",
"Chitlapakkam",
"Choolai",
"Choolaimedu",
"Chrompet",
"Egmore",
"Ekkaduthangal",
"Eranavur",
"Ennore",
"Foreshore Estate",
"Fort St. George",
"George Town",
"Gopalapuram",
"Government Estate",
"Guindy",
"Guduvancheri",
"IIT Madras",
"Injambakkam",
"ICF",
"Iyyapanthangal",
"Jafferkhanpet",
"Kadambathur",
"Karapakkam",
"Kattivakkam",
"Kattupakkam",
"Kazhipattur",
"K.K. Nagar",
"Keelkattalai",
"Kattivakkam",
"Kilpauk",
"Kodambakkam",
"Kodungaiyur",
"Kolathur",
"Korattur",
"Korukkupet",
"Kottivakkam",
"Kotturpuram",
"Kottur",
"Kovur",
"Koyambedu",
"Kundrathur",
"Madhavaram",
"Madhavaram Milk Colony",
"Madipakkam",
"Madambakkam",
"Maduravoyal",
"Manali",
"Manali New Town",
"Manapakkam",
"Mandaveli",
"Mangadu",
"Mannady",
"Mathur",
"Medavakkam",
"Meenambakkam",
"MGR Nagar",
"Minjur",
"Mogappair",
"MKB Nagar",
"Mount Road",
"Moolakadai",
"Moulivakkam",
"Mugalivakkam",
"Mudichur",
"Mylapore",
"Nandanam",
"Nanganallur",
"Nanmangalam",
"Neelankarai",
"Nemilichery",
"Nesapakkam",
"Nolambur",
"Noombal",
"Nungambakkam",
"Otteri",
"Padi",
"Pakkam",
"Palavakkam",
"Pallavaram",
"Pallikaranai",
"Pammal",
"Park Town",
"Parry's Corner",
"Pattabiram",
"Pattaravakkam",
"Pazhavanthangal",
"Peerkankaranai",
"Perambur",
"Peravallur",
"Perumbakkam",
"Perungalathur",
"Perungudi",
"Pozhichalur",
"Poonamallee",
"Porur",
"Pudupet",
"Pulianthope",
"Purasaiwalkam",
"Puthagaram",
"Puzhal",
"Puzhuthivakkam/ Ullagaram",
"Raj Bhavan",
"Ramavaram",
"Red Hills",
"Royapettah",
"Royapuram",
"Saidapet",
"Saligramam",
"Santhome",
"Sembakkam",
"Selaiyur",
"Shenoy Nagar",
"Sholavaram",
"Sholinganallur",
"Sikkarayapuram",
"Sowcarpet",
"St.Thomas Mount",
"Surapet",
"Tambaram",
"Teynampet",
"Tharamani",
"T. Nagar",
"Thirumangalam",
"Thirumullaivoyal",
"Thiruninravur",
"Thiruvanmiyur",
"Thiruvallur",
"Tiruverkadu",
"Thiruvotriyur",
"Thuraipakkam",
"Tirusulam",
"Tiruvallikeni",
"Tondiarpet",
"United India Colony",
"Vandalur",
"Vadapalani",
"Valasaravakkam",
"Vallalar Nagar",
"Vanagaram",
"Velachery",
"Velappanchavadi",
"Villivakkam",
"Virugambakkam",
"Vyasarpadi",
"Washermanpet",
"West Mambalam",
];
final db = FirebaseFirestore.instance;

class Getfood extends StatefulWidget {
  const Getfood({super.key});

  @override
  State<Getfood> createState() => _GetfoodPageState();
}

class _GetfoodPageState extends State<Getfood> {
  String selectedArea = "";
  List restaurants = [];
  bool _loading = true;

  loadData(String area) async {
    print("function started");
    setState(() {
  selectedArea = area;
});
    restaurants.clear();
    final docRef = await db.collection(area).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        restaurants.add(docSnapshot.data());
        print(docSnapshot.data());
        print(restaurants);
      }
    });
setState(() {
  _loading = false;
});    
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
               restaurants.isNotEmpty ? Expanded(
               child: ListView.builder(
                 padding: const EdgeInsets.all(16),
                 itemCount: restaurants[0]["fooditems"].length,
                 itemBuilder: (BuildContext context, index) {
                   var foodItems = restaurants[0]["fooditems"];
               
                   if (index < foodItems.length) {
                     var foodItem = foodItems[index];
                     var imageUrls = foodItem["imageUrls"];
                     var imageUrl = foodItem["imageUrls"][0];
                     print("------------------------------$imageUrl");
                     var shopName = foodItem["shopname"];
                     var shopNumber = foodItem["shopmobile"];
                     var shopAddress = foodItem["shopaddress"];
                     var itemDescription = foodItem["itemDescription"];
                     var dateofproduce = foodItem["dateofproduce"];
                     double price = foodItem["price"] ?? 0.0;
               
                     return GestureDetector(
                       onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => Fooddescription(area: selectedArea , shopNumber: shopNumber, shopName: shopName, shopAddress: shopAddress, itemDescription: itemDescription, imageUrls: imageUrls, price: price,)));
                       },
                       child: SquareImageCard(
                         imageUrl: imageUrl,
                         shopName: shopName,
                         price: price,
                       ),
                     );
                   }
                   return null;
                 },
               ),
                          )   : Center(child: Text(_loading ? "Select Area": "No food items available",style: const TextStyle(fontSize: 18, color: Colors.grey),),)
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
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(height: 300,
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
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imageUrl,fit: BoxFit.cover,width: double.infinity,
                  ),
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
                    '₹${price.toString()}',
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
