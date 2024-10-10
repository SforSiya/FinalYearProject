import 'package:flutter/material.dart';

class LevelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get the screen size for responsiveness

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Level'),
        centerTitle: true, // Center title in AppBar
        backgroundColor: Colors.deepPurpleAccent, // Custom AppBar color
        elevation: 5.0, // AppBar shadow
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Level 1 Button
                _buildLevelButton(context, 'Level 1', size),
                SizedBox(height: 30), // Space between buttons
                // Level 2 Button
                _buildLevelButton(context, 'Level 2', size),
                SizedBox(height: 30), // Space between buttons
                // Level 3 Button
                _buildLevelButton(context, 'Level 3', size),
                SizedBox(height: 30), // Space between buttons
                // Level 4 Button
                _buildLevelButton(context, 'Level 4', size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build a round button for each level
  Widget _buildLevelButton(BuildContext context, String level, Size size) {
    return ElevatedButton(
      onPressed: () {
        // Add your onPressed functionality here (like navigating to another page)
        print('$level pressed');
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), // Make the button round
        padding: EdgeInsets.all(size.width * 0.1), // Dynamic size based on screen width
        backgroundColor: Colors.white, // Button background color
        elevation: 10, // Shadow for a 3D effect
        shadowColor: Colors.black38, // Shadow color
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: size.width * 0.05, // Dynamic font size based on screen width
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent, // Text color
        ),
      ),
    );
  }
}

