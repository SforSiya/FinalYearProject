import 'package:flutter/material.dart';

class ResultScreenShape extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String userId;

  ResultScreenShape({
    required this.score,
    required this.totalQuestions,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
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
