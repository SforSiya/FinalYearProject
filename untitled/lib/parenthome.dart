import 'package:flutter/material.dart';
 // Import the chat room screen

class ParentHome extends StatelessWidget {
  const ParentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Parents Dashboard',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              backgroundColor: Colors.teal,
            ),),
          centerTitle: true,
        ),
        body: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: const <Widget>[
                      Text('Hello Parent',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),),
                    ],
                  ),
                  const CircleAvatar(
                    minRadius: 10,
                    maxRadius: 30,
                  ),
                ],
              ),

              const SizedBox(height: 20)
            ]
        )
    );
  }
}
