import 'package:flutter/material.dart';

class ResultScreenShape extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String userId;

  const ResultScreenShape({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'You scored $score out of $totalQuestions',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the shape screen to play again
                Navigator.pop(context);
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
