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
    // Get the size of the device's screen for responsiveness
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50], // Pastel purple background
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            color: Colors.purple[600], // Darker purple for text
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Added SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Picture (Placeholder for future expansion)
              CircleAvatar(
                radius: width * 0.12,
                backgroundColor: Colors.purple[100],
                child: Icon(
                  Icons.person,
                  size: width * 0.1,
                  color: Colors.purple[400],
                ),
              ),
              SizedBox(height: height * 0.03), // Spacing

              // Display Username
              Text(
                userData?['username'] ?? 'No username available',
                style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[600], // Pastel purple for username
                ),
              ),
              SizedBox(height: height * 0.03), // Spacing

              // Email and Password Display
              buildProfileItem(
                label: 'Your Email',
                value: userData?['email'] ?? 'No email available',
                icon: Icons.email,
                width: width,
              ),
              buildProfileItem(
                label: 'Password',
                value: userData?['password'] ?? 'No password available',
                icon: Icons.lock,
                width: width,
              ),
              SizedBox(height: height * 0.04), // Spacing

              // Logout Button
              buildLogoutButton(context, width),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display profile information
  Widget buildProfileItem(
      {required String label, required String value, required IconData icon, required double width}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: width * 0.04, // Responsive font size for label
              color: Colors.purple[300], // Light pastel purple for label
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.purple[50], // Very light purple background
              borderRadius: BorderRadius.circular(15), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1), // Subtle shadow effect
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.purple[400]), // Icon color to match theme
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: width * 0.045, // Responsive font size for value
                      color: Colors.purple[600], // Text color
                    ),
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
  Widget buildLogoutButton(BuildContext context, double width) {
    return SizedBox(
      width: width * 0.9, // Responsive button width
      child: ElevatedButton(
        onPressed: () async {
          try {
            await _auth.signOut(); // Logs out the user
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error logging out: $e')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[400], // Pastel purple color for button
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: width * 0.05, // Responsive font size for button text
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
