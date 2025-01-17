import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/login.dart';
import 'package:foodex/screen/contact.dart';
import 'package:foodex/screen/merchantOrders.dart';
import 'package:foodex/widgets/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

final db = FirebaseFirestore.instance;

class MerchantNavigationScreen extends StatefulWidget {
  const MerchantNavigationScreen({super.key});

  @override
  State<MerchantNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<MerchantNavigationScreen> {
  int _selectedIndex = 0;
   static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  final List<Widget> _widgetOptions = <Widget>[

     const HomeScreen(),
      const merchantOrders(),
      const ContactUsPage()
 
  ];
      static const List<String> _screenTitles = [
    'Home',
    'Orders',
    'Contact Us',
  ];

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

    void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your log out functionality here
                _logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

    void _logout() async {
    // Implement your log out logic here
    // For example, clear user data, navigate to login screen, etc.
    await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const LoginScreen()));

  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true,
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
              decoration: const BoxDecoration(
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
              title:  Text('Orders',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20.sp)),
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
            ListTile(
              title:  Text('Log Out',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20.sp)),
              onTap: () {
                                        _showLogoutDialog(context);


              },
            ),
          ],
        ),
      ),
    );
  }
}