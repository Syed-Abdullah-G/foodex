import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodex/getDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();


  Future<UserCredential> signInWithGoogle() async {
    //trigger the authentication flow 
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    //Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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


           

            //add google login here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 164, 200, 183),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      await signInWithGoogle();
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const Getdetails()));

                    },
                    child: const Text('Google Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
