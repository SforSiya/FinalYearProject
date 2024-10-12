import 'package:flutter/material.dart';
import 'package:mathmind/patient/Kids_screens/games/shape_game/screens_ShapeGame/shape_splash_screen.dart';

import 'Addition_Game/first_page.dart';
import 'levels_game/level_game.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: Container(
        color: Colors.blue[50], // Light blue background to match your image
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Let's Play",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent, // Pink color for text as in the image
              ),
            ),
            const SizedBox(height: 30),
            buildGameButton(
              context,
              'Addition',
              Icons.add,
              Colors.redAccent,
              Colors.red[100],
                  () {
                // Navigate to the addition game
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  StartScreen(), // Replace with your actual page
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            buildGameButton(
              context,
              'Shapes',
              Icons.category,
              Colors.pinkAccent,
              Colors.pink[100],
                  () {
                // Navigate to the shapes game
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ShapeSplashScreen(), // Replace with your actual page
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            buildGameButton(
              context,
              'Match',
              Icons.linear_scale,
              Colors.purpleAccent,
              Colors.purple[100],
                  () {
                // Navigate to the matching game
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SplashScreen_lvl(), // Replace with your actual page
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGameButton(
      BuildContext context, String title, IconData icon, Color textColor, Color? backgroundColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: textColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




