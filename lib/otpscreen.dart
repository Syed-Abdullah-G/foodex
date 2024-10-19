import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodex/getDetails.dart';
import 'package:google_fonts/google_fonts.dart';

class Otpscreen extends StatefulWidget {
  const Otpscreen({super.key, required this.vertificationId, required this.mobileNumber, });

  final String vertificationId;
  final String mobileNumber;

  @override
  State<Otpscreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<Otpscreen> {
  final _smsCodeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

            Text("Enter OTP", style: GoogleFonts.bebasNeue(fontSize: 52)),
            const SizedBox(
              height: 10,
            ),
            Text(
              "OTP is sent to ${widget.mobileNumber}",
              style: const TextStyle(
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
                    controller: _smsCodeController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter OTP",
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),

            // sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      String smsCode = _smsCodeController.text;

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.vertificationId, smsCode: smsCode);
                              print("----------User successfully created------------");

                      try {
                       
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Getdetails(),));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
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
