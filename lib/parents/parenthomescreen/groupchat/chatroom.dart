import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatRoomScreen extends StatefulWidget {
  final String currentUser;
  final String groupId;
  final String currentUserName;

  ChatRoomScreen({
    required this.currentUser,
    required this.groupId,
    required this.currentUserName,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  File? _image;
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      FirebaseFirestore.instance
          .collection('messages')
          .where('groupId', isEqualTo: widget.groupId)
          .orderBy('timestamp') // Sort by timestamp
          .snapshots()
          .listen((snapshot) {
        setState(() {
          _messages.clear();
          for (var doc in snapshot.docs) {
            _messages.add(doc.data() as Map<String, dynamic>);
          }
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching messages: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _addMessage(isImage: true);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selection canceled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  Future<void> _addMessage({bool isImage = false}) async {
    if (_messageController.text.isNotEmpty || isImage) {
      final timestamp = FieldValue
          .serverTimestamp(); // Use Firestore's server timestamp

      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'sender': widget.currentUser,
          'senderName': widget.currentUserName,
          'text': isImage ? null : _messageController.text,
          'image': isImage ? await _uploadImage() : null,
          // Implement upload if necessary
          'timestamp': timestamp,
          'groupId': widget.groupId,
        });

        setState(() {
          _messageController.clear();
          _image = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message or select an image')),
      );
    }
  }

  Future<String?> _uploadImage() async {
    // Implement image upload logic and return the image URL
    // For example, you can use Firebase Storage to store the image and return its URL
    return null; // Replace with actual upload implementation
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300], // Updated to purple theme
        title: Text(
          'Group Chat',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Align(
                    alignment: message['sender'] == widget.currentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message['sender'] == widget.currentUser
                            ? Colors
                            .deepPurple[300] // Current user's message in theme color
                            : Colors.deepPurple[50],
                        // Other user's message in soft purple
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: message['sender'] == widget.currentUser
                              ? Radius.circular(16)
                              : Radius.zero,
                          bottomRight: message['sender'] != widget.currentUser
                              ? Radius.circular(16)
                              : Radius.zero,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['senderName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: message['sender'] == widget.currentUser
                                  ? Colors.white
                                  : Colors
                                  .deepPurple[800], // Dark text for contrast
                            ),
                          ),
                          SizedBox(height: 5),
                          if (message['image'] != null)
                            Image.network(message['image']) // Display image URL
                          else
                            Text(
                              message['text'] ?? '',
                              style: TextStyle(
                                color: message['sender'] == widget.currentUser
                                    ? Colors.white
                                    : Colors
                                    .deepPurple[800], // Dark text for contrast
                              ),
                            ),
                          SizedBox(height: 5),
                          Text(
                            (message['timestamp'] as Timestamp)
                                .toDate()
                                .toString(), // Format timestamp
                            style: TextStyle(
                              fontSize: 10,
                              color: message['sender'] == widget.currentUser
                                  ? Colors.white70
                                  : Colors.deepPurple[300], // Timestamp color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_a_photo, color: Colors.deepPurple[300]),
                  // Updated to purple
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.deepPurple[300]),
                      // Hint text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple[300]),
                  // Send icon in purple
                  onPressed: _addMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}