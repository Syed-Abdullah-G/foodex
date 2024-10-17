import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodex/getDetails.dart';
import 'package:foodex/login.dart';
import 'package:google_fonts/google_fonts.dart';

class Redirect extends StatefulWidget {
  const Redirect({super.key});

  @override
  State<Redirect> createState() => _HomepageState();
}

class _HomepageState extends State<Redirect> {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.hasData) {
            return Getdetails();
          } else {
            return LoginPage();
          }
        },
      ));
}
