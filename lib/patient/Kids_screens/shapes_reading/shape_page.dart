import 'package:flutter/material.dart';

class ShapesPage extends StatelessWidget {
  const ShapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapes'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Container(
        color: Colors.yellow[50],
        child: const Center(
          child: Text('Shapes Page', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
