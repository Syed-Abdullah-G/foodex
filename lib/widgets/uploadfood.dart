import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodex/event_details.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required this.shopname, required this.address, required this.shopnumber, required this.name, required this.imagePath});

  String shopname;
  String address;
  String shopnumber;
  String name;
  String imagePath;

  @override
  State<HomeScreen> createState() => _UploadfoodState();
}

class _UploadfoodState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(248, 213, 108, 108),
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
        child: const Icon(
          Icons.fastfood_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: CachedNetworkImage(
                imageUrl: widget.imagePath,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.shopname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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
