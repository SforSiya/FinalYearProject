import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mathmind/patient/Kids_screens/games/shape_game/main_shape_file.dart';
import 'package:mathmind/patient/Kids_screens/games/shape_game/screens_ShapeGame/result_shape_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ShapeScreen extends StatefulWidget {
  @override
  _ShapeScreenState createState() => _ShapeScreenState();
}

class _ShapeScreenState extends State<ShapeScreen> {
  final List<String> shapes = ["Rectangle", "Circle", "Square", "Triangle", "Pentagon", "Quadrilateral", "Star", "Hexagon"];
  Random random = Random();
  int currentShapeIndex = 0;
  int questionCount = 0;
  int correctAnswers = 0;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    _generateNewShape();
  }


  void _generateNewShape() {
    setState(() {
      if (questionCount < shapes.length) {
        currentShapeIndex = random.nextInt(shapes.length);
        options = [shapes[currentShapeIndex]];

        while (options.length < 3) {
          String incorrectShape = shapes[random.nextInt(shapes.length)];
          if (!options.contains(incorrectShape)) {
            options.add(incorrectShape);
          }
        }
        options.shuffle();
        questionCount++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreenShape(score: correctAnswers,totalQuestions: shapes.length,)),
        );
      }
    });
  }

  void _checkAnswer(String selectedShape) {
    bool isCorrect = selectedShape == shapes[currentShapeIndex];
    if (isCorrect) {
      correctAnswers++;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isCorrect ? Colors.green[50] : Colors.red[50],
        title: Text(isCorrect ? "Well Done!" : "Incorrect!"),
        actions: [
          TextButton(
            child: Text("Next"),
            onPressed: () {
              Navigator.of(context).pop();
              _generateNewShape();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shape Game'), backgroundColor: Color(0xFF88AB8E)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Guess the Shape!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.purple)),
          SizedBox(height: 40),
          Center(child: Icon(Icons.star, size: 100, color: Colors.pink)), // Replace with your shape widget
          SizedBox(height: 30),
          ...options.map((option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAFC8AD),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () => _checkAnswer(option),
              child: Text(option, style: TextStyle(fontSize: 22)),
            ),
          )),
        ],
      ),
    );
  }
}
