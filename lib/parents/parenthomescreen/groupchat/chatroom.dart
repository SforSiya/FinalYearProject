import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatRoomScreen extends StatefulWidget {
  final String currentUser;

  ChatRoomScreen({required this.currentUser});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  File? _image;
  bool _isLoadingImage = false;

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

  void _addMessage({bool isImage = false}) {
    if (_messageController.text.isNotEmpty || isImage) {
      setState(() {
        _messages.add({
          'sender': widget.currentUser,
          'text': isImage ? null : _messageController.text,
          'image': isImage ? _image : null,
        });
        _messageController.clear();
        _image = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message or select an image')),
      );
    }
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
        title: Text('Group Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text('${message['sender']}'),
                  subtitle:
                  message['text'] != null ? Text(message['text']) : null,
                  trailing: message['image'] != null
                      ? Image.file(
                    message['image'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: _isLoadingImage
                      ? CircularProgressIndicator()
                      : Icon(Icons.image),
                  onPressed: _isLoadingImage
                      ? null
                      : () async {
                    setState(() {
                      _isLoadingImage = true;
                    });
                    await _pickImage();
                    setState(() {
                      _isLoadingImage = false;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _addMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}