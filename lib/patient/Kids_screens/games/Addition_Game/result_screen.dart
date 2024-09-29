import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

class Result_Screen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const Result_Screen(
      {super.key, required this.score, required this.totalQuestions});

  @override
  _Result_ScreenState createState() => _Result_ScreenState();
}

class _Result_ScreenState extends State<Result_Screen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Over')),
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
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(
                horizontal: 24.0), // Adjust margin as needed
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
              children: [
                Text(
                  'Total Questions Answered: ${widget.totalQuestions}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Correct Answers: ${widget.score}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: ${(widget.score / widget.totalQuestions * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                    'Play Again',
                    style: TextStyle(
                      color: Color(0xFF9CA986),
                    ),
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
