import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultScreenShape extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreenShape({super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDC8686),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final incorrectAnswers = totalQuestions - score;
          final scorePercentage = score / totalQuestions;

          // Dynamically adjust the size for circular indicators based on screen size
          final circleSize = screenWidth < 600 ? screenWidth * 0.5 : screenWidth * 0.25;
          final textFontSize = screenWidth < 600 ? screenWidth * 0.08 : screenWidth * 0.05;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                    child: Text(
                      'Your Score:',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background for incorrect answers (Red)
                      SizedBox(
                        height: circleSize,
                        width: circleSize,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 10.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      // Foreground showing correct answers (Green)
                      SizedBox(
                        height: circleSize,
                        width: circleSize,
                        child: CircularProgressIndicator(
                          value: scorePercentage,
                          strokeWidth: 10.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      // Score Text
                      Text(
                        '$score / $totalQuestions',
                        style: TextStyle(
                          fontSize: textFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  // Display correct and incorrect answers
                  Text(
                    'Correct Answers: $score',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? screenWidth * 0.06 : screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Incorrect Answers: $incorrectAnswers',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? screenWidth * 0.06 : screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF9ADCFF),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? screenWidth * 0.05 : screenWidth * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
