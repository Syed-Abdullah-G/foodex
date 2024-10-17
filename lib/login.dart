import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodex/redirect.dart';
import 'package:foodex/otpscreen.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();


   Future authenticate(String mobileNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91 $mobileNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          print("The provided phone number is not valid");
        }
      },
      codeSent: (String verificationID, int? resendToken) async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Otpscreen(vertificationId: verificationID, mobileNumber: mobileNumber,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mobileNumberController.dispose();
    _smsCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_android,
              size: 100,
            ),
            const SizedBox(
              height: 75,
            ),

            Text("Hello Again !", style: GoogleFonts.bebasNeue(fontSize: 52)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Welcome back !",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 50,
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _mobileNumberController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Mobie Number",
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),


            // sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      await authenticate(_mobileNumberController.text);
                    },
                    child: const Text('Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " Register Now",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
