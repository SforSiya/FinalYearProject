import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart'; // Import the animated background package
import 'game_screen.dart'; // Import the GameScreen file

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Screen"),
        backgroundColor: const Color(0xFF88AB8E), // Your title bar color
      ),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 30, // Radius of background objects
            spawnMinSpeed: 15, // Minimum speed of objects moving
            particleCount: 80, // Number of objects in the background
            spawnMaxSpeed: 30, // Maximum speed of objects moving
            baseColor: Color(0xFF9CA986), // Background object color
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: const Color(0xFF9CA986),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Numbers',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Test your addition skills in this fun game. '
                  'You have 30 seconds to answer as many questions as you can. '
                  'Try to get as many correct answers as possible!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0), // Adjust the padding for size
                    textStyle: const TextStyle(
                      fontSize: 18, // Adjust font size as needed
                    ),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(color: Color(0xFF9CA986)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
