import 'package:flutter/material.dart';
import 'package:foodex/event_details.dart';

class Uploadfood extends StatefulWidget {
   Uploadfood({super.key, required this.shopname, required this.address, required this.shopnumber, required this.name});

  String shopname;
  String address;
  String shopnumber;
  String name;



  @override
  State<Uploadfood> createState() => _UploadfoodState();
}

class _UploadfoodState extends State<Uploadfood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(floatingActionButton: FloatingActionButton(backgroundColor: const Color.fromARGB(248, 213, 108, 108),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExpenseScreen(
                        shopname: widget.shopname,
                        shopnumber: widget.shopnumber,
                        address: widget.address,
                      )));
        },
        child: const Icon(Icons.fastfood_outlined,color: Colors.white,),
      ),      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body
      : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
      
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/userPhoto/A2B.jpg'), // Add your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                widget.shopname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                 Text(
                  widget.address,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  widget.shopnumber,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}