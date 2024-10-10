
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Result_Screen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  Result_Screen({required this.score, required this.totalQuestions});

  @override
  _Result_ScreenState createState() => _Result_ScreenState();
}

class _Result_ScreenState extends State<Result_Screen> with SingleTickerProviderStateMixin {
  bool _isUpdating = false; // State variable to track if the score is updating

  @override
  void initState() {
    super.initState();
    _updateHighScore(); // Call the function when the widget is initialized
  }

  // Function to update the high score for the addition game in Firestore
  Future<void> _updateHighScore() async {
    setState(() {
      _isUpdating = true; // Set the updating state to true
    });

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's ID
    final String gameName = 'additionGame'; // Define the game name

    // Reference to the user's game data subcollection and game document
    final DocumentReference gameDataRef = firestore
        .collection('users')
        .doc(userId)
        .collection('gameData')
        .doc(gameName); // Use gameName to store different games

    try {
      // Fetch the current highest score from Firestore for this game
      final DocumentSnapshot gameDataSnapshot = await gameDataRef.get();

      if (gameDataSnapshot.exists) {
        // If the document exists, compare the current score with the saved highest score
        int currentHighestScore = gameDataSnapshot['highestScore'] ?? 0;

        // If the current score is higher than the saved score, update it
        if (widget.score > currentHighestScore) {
          await gameDataRef.set({
            'highestScore': widget.score,
            'lastPlayed': Timestamp.now(), // Optionally track the last time the game was played
          }, SetOptions(merge: true));
          print("New highest score saved for addition game!");
        } else {
          print("Score is lower than the current highest score for addition game, not updated.");
        }
      } else {
        // If the document doesn't exist, create it with the current score
        await gameDataRef.set({
          'highestScore': widget.score,
          'lastPlayed': Timestamp.now(), // Optionally track the last time the game was played
        });
        print("Highest score document created for addition game!");
      }
    } catch (e) {
      print("Error updating highest score: $e");
    } finally {
      setState(() {
        _isUpdating = false; // Reset the updating state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Over')),
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
          child: _isUpdating
              ? CircularProgressIndicator() // Show loading indicator while updating
              : Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 24.0), // Adjust margin as needed
            decoration: BoxDecoration(
              color: Color(0xFF9CA986),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Correct Answers: ${widget.score}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Score: ${(widget.score / widget.totalQuestions * 100).toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Adjust the padding for size
                    textStyle: TextStyle(
                      fontSize: 18, // Adjust font size as needed
                    ),
                  ),
                  child: Text(
                    'Play Again',
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

