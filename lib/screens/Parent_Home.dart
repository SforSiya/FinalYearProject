import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../parent/groupchat/chatroom.dart';
import '../parent/parenthome/parent_profile.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  bool _isInGroup = false;
  final String _groupId = '7Lx18qsDRQ2B1PyZsaf1'; // Replace with actual group document ID
  String? username;

  @override
  void initState() {
    super.initState();
    _checkIfUserInGroup();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc['username']; // Assuming 'username' is the field name
      });
    }
  }

  Future<void> _checkIfUserInGroup() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String currentUserId = user.uid;

    // Reference to the group document
    DocumentReference groupDoc =
    FirebaseFirestore.instance.collection('group').doc(_groupId);

    DocumentSnapshot groupSnapshot = await groupDoc.get();

    if (groupSnapshot.exists) {
      List<dynamic> members = groupSnapshot['members'] ?? [];

      if (members.contains(currentUserId)) {
        setState(() {
          _isInGroup = true;
        });
      }
    }
  }

  // Show the dialog to join the group
  void _showJoinGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Group'),
          content: const Text('Do you want to join the group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to join the group')),
                  );
                  return;
                }

                String currentUserId = user.uid;

                // Add the user to the group's members array in Firestore
                DocumentReference groupDoc =
                FirebaseFirestore.instance.collection('group').doc(_groupId);
                await groupDoc.update({
                  'members': FieldValue.arrayUnion([currentUserId]),
                });

                setState(() {
                  _isInGroup = true;
                });

                // Notify user they joined the group
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You joined the group!')),
                );

                Navigator.of(context).pop();

                // Navigate to chat room
                Future.microtask(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        currentUser: currentUserId,
                        groupId: _groupId,
                        currentUserName: username ?? 'User', // Pass the username or default to 'User'
                      ),
                    ),
                  );
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParentProfile()),
              );
            },
          ),
        ],
        title: const Center(
          child: Text(
            'Parents Dashboard',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10), // Space for the status bar
              // First Box (Hey Parent)
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Hey Parent',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Second Box (Join Group)
              GestureDetector(
                onTap: () {
                  if (_isInGroup) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(
                          currentUser: FirebaseAuth.instance.currentUser!.uid,
                          groupId: _groupId,
                          currentUserName: username ?? 'User',
                        ),
                      ),
                    );
                  } else {
                    _showJoinGroupDialog(context);
                  }
                },
                child: Container(
                  height: 65,
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Transparent white for glass effect
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3), // Subtle border for glass effect
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur for glass look
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center text and icon
                          children: [
                            Text(
                              'Join Support Group',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.add,
                              color: Colors.blue[300],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Row with two boxes (Plans for Today and Image Notes)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          'Educational Material',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Homework Box
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Psychatrist Hunt',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}