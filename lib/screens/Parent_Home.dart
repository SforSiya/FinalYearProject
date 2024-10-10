import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> childrenData;

  ParentHomeScreen({required this.childrenData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Home'),
      ),
      body: ListView.builder(
        itemCount: childrenData.length,
        itemBuilder: (context, index) {
          final child = childrenData[index];
          return ListTile(
            title: Text(child['username'] ?? 'Unknown'),
            subtitle: Text('Email: ${child['email'] ?? 'N/A'}'),
          );
        },
      ),
    );
  }
}

