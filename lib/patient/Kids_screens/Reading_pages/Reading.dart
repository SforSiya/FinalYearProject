import 'package:flutter/material.dart';

class ReadingPage extends StatelessWidget {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        color: Colors.lightGreen[50],
        child: const Center(
          child: Text('Reading Page', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
