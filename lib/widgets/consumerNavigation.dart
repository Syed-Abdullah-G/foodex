import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/login.dart';
import 'package:foodex/screen/contact.dart';
import 'package:foodex/screen/getfood.dart';
import 'package:foodex/screen/userOrders.dart';
import 'package:google_fonts/google_fonts.dart';

class consumerNavigationScreen extends StatefulWidget {
  const consumerNavigationScreen({super.key});

  @override
  State<consumerNavigationScreen> createState() => _consumerNavigationScreenState();
}

class _consumerNavigationScreenState extends State<consumerNavigationScreen> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
   Getfood(),
   usersOrders(),
   ContactUsPage(),
  ];

    static const List<String> _screenTitles = [
    'Get Food',
    'My Orders',
    'Contact Us',
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text(
          _screenTitles[_selectedIndex],
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu,size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Center(child: Image.asset("assets/menu_graphic/menu.png")),
            ),
            ListTile(
              title: Text('Home',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20.sp),),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title:  Text('My Orders',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20.sp)),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title:  Text('Contact Us',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20.sp)),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}