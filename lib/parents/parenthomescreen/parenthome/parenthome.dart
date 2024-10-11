import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathmind/parents/parenthomescreen/groupchat/chatroom.dart';  // Import the chat room screen

class ParentHome extends StatelessWidget {
  const ParentHome({super.key});

  // Function to show join group dialog
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Get the current user from Firebase Auth
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  // Handle unauthenticated user
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to join the group')),
                  );
                  return;
                }

                String currentUserId = user.uid;

                // Reference to the group collection in Firestore
                CollectionReference groupCollection = FirebaseFirestore.instance.collection('group');

                // Query Firestore to check if the user is already in a group or create a new one
                QuerySnapshot groupSnapshot = await groupCollection
                    .where('members', arrayContains: currentUserId)
                    .get();

                DocumentReference groupRef;
                String groupId;

                if (groupSnapshot.docs.isEmpty) {
                  // If the user is not already in a group, create a new group and add the user
                  groupRef = groupCollection.doc(); // Auto-generate groupId
                  groupId = groupRef.id; // Get the generated groupId

                  await groupRef.set({
                    'members': [currentUserId], // Add the current user as the first member
                  });

                  print('New group created with ID: $groupId');
                } else {
                  // If the user is already in a group, get the existing group
                  groupRef = groupSnapshot.docs.first.reference;
                  groupId = groupRef.id; // Get the existing groupId

                  await groupRef.update({
                    'members': FieldValue.arrayUnion([currentUserId]), // Add user to members list if not already there
                  });

                  print('Joined existing group with ID: $groupId');
                }

                // Show a snackbar to confirm joining the group
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You joined the group!')),
                );

                // Then, pop the route
                Navigator.of(context).pop();

                // Use microtask to delay navigation safely after the current frame
                Future.microtask(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(currentUser: currentUserId),
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
        title: const Text('Parents Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Column(
                children: const <Widget>[
                  Text('Hello'),
                  Text('Parent'),
                ],
              ),
              const CircleAvatar(
                minRadius: 10,
                maxRadius: 30,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => _showJoinGroupDialog(context), // Trigger the join group dialog
              child: Container(
                height: 82,
                width: 277,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text('Psychiatrist Hunt'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => _showJoinGroupDialog(context), // Trigger the join group dialog
              child: Container(
                height: 82,
                width: 277,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text('Join Support Group'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}