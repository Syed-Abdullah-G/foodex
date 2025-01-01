import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodex/constants/colors.dart';
import 'package:foodex/login.dart';
import 'package:foodex/screen/merchantNavigationscreen.dart';
import 'package:foodex/widgets/consumerNavigation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class existingLogin extends StatefulWidget {
  const existingLogin({super.key});

  @override
  State<existingLogin> createState() => _existingLoginState();
}

class _existingLoginState extends State<existingLogin> {
    String accountType = "";
      bool isLoading = false;



  Future<String> merchantlogin() async {
    
    setState(() => isLoading = true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return "";
      }

  

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      // Sign in to Firebase with the Google credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                  final userid = FirebaseAuth.instance.currentUser!.email;

  DocumentReference accountExists = FirebaseFirestore.instance.collection("user").doc(userid);
  


  DocumentSnapshot snapshot = await accountExists.get();

  if (snapshot.exists) {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MerchantNavigationScreen()));
  }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: ${e.toString()}')),
        );
      }
    }
    
return "";
   
  }


  Future<String> consumerlogin() async {
    
    setState(() => isLoading = true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return "";
      }

  

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      // Sign in to Firebase with the Google credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                  final userid = FirebaseAuth.instance.currentUser!.email;

  DocumentReference accountExists = FirebaseFirestore.instance.collection("consumer").doc(userid);
  


  DocumentSnapshot snapshot = await accountExists.get();

  if (snapshot.exists) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const consumerNavigationScreen()));
  }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: ${e.toString()}')),
        );
      }
    }
    
return "";
   
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 52.h,
              ),
              Text(
                "Login to FoodEx",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  color: darkTextColor,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                children: [
                  Text(
                    "Create an Account? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: lightTextColor,
                    ),
                  ),
TextButton(onPressed: (){
Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen(),));
}, child: Text("Create", style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: purpleColor,
                    ),))
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(backgroundColor: Colors.white,
                    label: Text(
                      'Customer',
                      style: TextStyle(
                        color: accountType == "customer" ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: accountType == "customer",
                    selectedColor: purpleColor,
                    onSelected: (bool selected) {
                      setState(() {
                        accountType = "customer";
                      });
                    },
                  ),
                  ChoiceChip(backgroundColor: Colors.white,
                    label: Text(
                      'Shop',
                      style: TextStyle(
                        color: accountType == "shop" ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: accountType == "shop",
                    selectedColor: purpleColor,
                    onSelected: (bool selected) {
                      setState(() {
                        accountType = "shop";
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: 20.h,),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    const razorpayId = "acc_PGXA5GFiAwFfLD";

                    if (accountType == "customer") {
                     consumerlogin();
                    } else if (accountType == "shop") {
                     merchantlogin();
                    } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please Select Customer or Shop")),
                        );
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
                      const Text("Login")
                    ],
                  ),
                ),
              ),
              ]))));
  }
}