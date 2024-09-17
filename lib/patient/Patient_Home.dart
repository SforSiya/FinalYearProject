import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

import 'Kids_screens/Kids_Home.dart';
import 'Teenager_screens/Teenager_Home.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final TextEditingController _ageController = TextEditingController();

  // Function to get the current user ID from Firebase Authentication
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // Variable to hold the username
  String? username;

  // Function to retrieve the username from Firestore using userId
  Future<void> _getUsername() async {
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc.data()?['username']; // Get the 'username' field from Firestore
        });
      }
    }
  }

  void _navigateBasedOnAge() async {
    final age = int.tryParse(_ageController.text);

    if (age == null) {
      // Handle invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }

    if (userId == null) {
      // Handle case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    // Fetch the username from Firestore
    await _getUsername();

    if (age > 12) {
      // Navigate to Teenager Home if age is above 12
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const teenager_home()));
    } else {
      // Navigate to Kids Home if age is 12 or below, and pass the username
      if (username != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KidsHome(username: username!), // Pass the username
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your age',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateBasedOnAge,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
