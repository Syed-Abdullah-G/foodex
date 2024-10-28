import 'package:flutter/material.dart';

class FoodGoSplash extends StatelessWidget {
  const FoodGoSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5350), // Red background color
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFEF5350),
                const Color(0xFFE53935),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo Text
              Text(
                'Foodex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico', // You'll need to add this font to pubspec.yaml
                ),
              ),
              const Spacer(flex: 1),
              // Burger Images
              Container(height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(bottom: 0,left: 0,
                      child: Image.asset(
                        'assets/userPhoto/biryani.png', // Add your burger image
                        height: 200,
                        width: 200,
                      ),
                    ),
                    Positioned(bottom: 0,left: 200,
                      child: Image.asset(
                        'assets/userPhoto/burger.png', // Add your burger image
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}