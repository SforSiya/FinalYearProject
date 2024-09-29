import 'package:flutter/material.dart';
import 'package:mathmind/parents/parenthomescreen/groupchat/chatroom.dart';
class ParentHome extends StatelessWidget {
  const ParentHome(
      {super.key}); //current user will be passed as an argument when parent screen be called

//to enter the group chat
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
              onPressed: () {
                // Close the dialog first
                Navigator.of(context).pop();
// Define your current user here. This should be replaced with the actual user data.
                String currentUser =
                    'example_user'; // Replace with your logic to get the current user

                // Navigate to the ChatRoomScreen with the required parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatRoomScreen(currentUser: currentUser),
                  ),
                );

                // Show a snackbar to confirm joining the group
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You joined the group!')),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
// showcasing parent home here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parents Dashboard',
        ),
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
                //foregroundImage: AssetImage(assetName),
              ),
            ],
          ),
          const SizedBox(height: 20), // Add some space between elements
          Center(
            child: GestureDetector(
              // move to next screen when tapped
              onTap: () => _showJoinGroupDialog(
                  context), // will lead to phychatrist page
              child: Container(
                height: 82,
                width: 277,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                      'Phychatrist Hunt'), // Center the text within the container
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Space between containers
          Center(
            child: GestureDetector(
              onTap: () => _showJoinGroupDialog(context), // Will lead to Group
              child: Container(
                height: 82,
                width: 277,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                      'Join Support Group'), // Center the text within the container
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}