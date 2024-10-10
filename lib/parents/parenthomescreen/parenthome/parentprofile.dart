import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../screens/login_screen.dart';

class ParentProfile extends StatefulWidget {
  @override
  _ParentProfileState createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser; // Get the current logged-in user
    fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    if (user != null) {
      final uid = user!.uid;
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100], // Lighter purple background
        elevation: 0,
        title: Text(
          'Your Profile',
          style: TextStyle(
            fontSize: 20,
            color: Colors.deepPurple[600], // Darker purple for text
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple[100],
              // Lighter purple for avatar background
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.deepPurple[600], // Darker purple for icon
              ),
            ),
            SizedBox(height: 20),
            Text(
              userData?['username'] ?? 'No username',
              // Check if username exists
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[600], // Darker purple for text
              ),
            ),
            SizedBox(height: 20),
            buildProfileItem(
              label: 'Your Email',
              value: userData?['email'] ?? 'No email available',
              // Check if email exists
              icon: Icons.email,
            ),
            buildProfileItem(
              label: 'Password',
              value: userData?['password'] ?? 'No password available',
              // Check if password exists
              icon: Icons.lock,
            ),
            Spacer(),
            buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

// Widget to display profile information
  Widget buildProfileItem(
      {required String label, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple[300], // Lighter text for labels
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              // Very light purple background
              borderRadius: BorderRadius.circular(15),
              // Rounded corners to match the theme
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  // Subtle shadow effect
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.deepPurple[400]),
                // Icon color to match the theme
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16,
                        color: Colors.deepPurple[600]), // Text color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Logout button widget
  Widget buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await _auth.signOut(); // Logs out the user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                    LoginScreen()), // Navigate to LoginScreen
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error logging out: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[400], // Purple color for button
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  15), // Rounded corners to match UI
            ),
          ),
          child: Text(
            'Logout',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
