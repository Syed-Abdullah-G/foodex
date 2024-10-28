
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:foodex/getDetails.dart';
// import 'package:foodex/userpage.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FoodGoSplash extends StatefulWidget {
//   const FoodGoSplash({Key? key}) : super(key: key);

//   @override
//   State<FoodGoSplash> createState() => _FoodGoSplashState();
// }

// class _FoodGoSplashState extends State<FoodGoSplash> {
//     bool _isLoading = false;



// Future<void> signInWithGoogle() async {
//     setState(() => _isLoading = true);
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => _isLoading = false);
//         return;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credential
//       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
//       // Check if user exists in Firestore
//       final userDoc = await FirebaseFirestore.instance
//           .collection("user")
//           .doc(userCredential.user!.uid)
//           .get();
      
//       if (mounted) {
//         // Navigate to appropriate screen based on user existence
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => userDoc.exists 
//               ? const ProfileScreen() 
//               : const Getdetails(),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error signing in: ${e.toString()}')),
//         );
//       }
//     }
//     setState(() => _isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEF5350), // Red background color
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ClipRRect(child: Image.asset("assets/userPhoto/logo.png")),
//               SizedBox(height: 75,),
//               Text("Sign In", style: GoogleFonts.bebasNeue(fontSize: 52),),
//               SizedBox(height: 50,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 50),
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : signInWithGoogle,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 1,
//                   ),
//                   child: _isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/userPhoto/google_logo.png',
//                             height: 24,
//                           ),
//                           const SizedBox(width: 12),
//                           const Text(
//                             'Sign in with Google',
//                             style: TextStyle(
//                               color: Colors.black87,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                 ),
//               )

//             ],
//           ),
//         )
//       ),
//     );
//   }
// }
