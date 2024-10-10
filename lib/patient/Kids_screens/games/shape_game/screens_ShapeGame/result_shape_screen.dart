import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultScreenShape extends StatelessWidget {
  final int score;  // The current score from the game
  final int totalQuestions;
  final String userId;  // The user's ID from Firebase Authentication

  ResultScreenShape({
    required this.score,
    required this.totalQuestions,
    required this.userId,
  });

  // Function to update the highest score and last 7 scores in Firestore
  Future<int> _updateGameData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the specific user's game data
    final DocumentReference gameDataRef = firestore
        .collection('users')
        .doc(userId)
        .collection('gameData')
        .doc('shapeGame'); // Assuming 'shapeGame' is the document for this game

    int currentHighestScore = 0;
    List<int> lastScores = [];

    try {
      final DocumentSnapshot gameDataSnapshot = await gameDataRef.get();

      // Check if the document already exists and cast the data to a map
      if (gameDataSnapshot.exists) {
        final data = gameDataSnapshot.data() as Map<String, dynamic>?;

        // Fetch the current highest score if it exists
        if (data != null) {
          currentHighestScore = data['highestScore'] ?? 0;

          // Check if the 'lastScores' field exists, if not initialize it as an empty list
          if (data.containsKey('lastScores')) {
            lastScores = List<int>.from(data['lastScores']);
          }
        }
      }

      // If the current score is higher than the highest saved score, update it
      if (score > currentHighestScore) {
        await gameDataRef.set({
          'highestScore': score,
          'lastPlayed': Timestamp.now(),
        }, SetOptions(merge: true));
        currentHighestScore = score;  // Set current highest score to the new score
      } else {
        await gameDataRef.set({
          'lastPlayed': Timestamp.now(),
        }, SetOptions(merge: true));
      }

      // Add the current score to the lastScores array
      lastScores.add(score);

      // Ensure that the array contains only the last 7 scores
      if (lastScores.length > 7) {
        lastScores = lastScores.sublist(lastScores.length - 7);
      }

      // Update the lastScores array in Firestore
      await gameDataRef.set({
        'lastScores': lastScores,
      }, SetOptions(merge: true));

      print("Game data updated successfully!");

    } catch (e) {
      print("Error updating game data: $e");
    }

    // Return the current highest score for display purposes
    return currentHighestScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Over')),
      body: FutureBuilder<int>(
        future: _updateGameData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            int highestScore = snapshot.data!;
            bool isNewHighScore = score == highestScore;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You scored $score out of $totalQuestions',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Highest Score: $highestScore',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isNewHighScore ? Colors.green : Colors.black),
                  ),
                  if (isNewHighScore) ...[
                    SizedBox(height: 10),
                    Text(
                      'New High Score!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to the shape screen to play again
                      Navigator.pop(context);
                    },
                    child: Text('Play Again'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultScreenShape extends StatelessWidget {
  final int score;  // The current score from the game
  final int totalQuestions;
  final String userId;  // The user's ID from Firebase Authentication

  ResultScreenShape({
    required this.score,
    required this.totalQuestions,
    required this.userId,
  });

  // Function to update the highest score in Firestore
  Future<void> _updateHighestScore() async {
    // Reference to the Firestore database
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the specific user's game data
    final DocumentReference gameDataRef = firestore
        .collection('users')
        .doc(userId)
        .collection('gameData')
        .doc('shapeGame');  // Assuming 'shapeGame' is the document for this specific game

    try {
      // Fetch the current highest score from Firestore
      final DocumentSnapshot gameDataSnapshot = await gameDataRef.get();

      if (gameDataSnapshot.exists) {
        // If the document exists, compare the current score with the saved highest score
        int currentHighestScore = gameDataSnapshot['highestScore'] ?? 0;

        // If the current score is higher than the saved score, update it
        if (score > currentHighestScore) {
          await gameDataRef.set({
            'highestScore': score,
            'lastPlayed': Timestamp.now(),  // Optionally track the last time the game was played
          }, SetOptions(merge: true));
          print("New highest score saved!");
        } else {
          print("Score is lower than the current highest score, not updated.");
        }
      } else {
        // If the document doesn't exist, create it with the current score
        await gameDataRef.set({
          'highestScore': score,
          'lastPlayed': Timestamp.now(),  // Optionally track the last time the game was played
        });
        print("Highest score document created!");
      }
    } catch (e) {
      print("Error updating highest score: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the function to update the highest score as soon as the screen builds
    _updateHighestScore();

    return Scaffold(
      appBar: AppBar(title: Text('Game Over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You scored $score out of $totalQuestions',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the shape screen to play again
                Navigator.pop(context);
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
*/