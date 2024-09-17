import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/splash_screen.gif', // Replace with your actual GIF path
              fit: BoxFit.cover, // Make sure the GIF covers the entire screen
            ),
          ),
          // Overlayed content (centered text)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "MathMind" text
                Text(
                  'MathMind',
                  style: TextStyle(
                    fontSize: 40, // Font size for the title
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text
                    // Replace with your chosen cute font
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
