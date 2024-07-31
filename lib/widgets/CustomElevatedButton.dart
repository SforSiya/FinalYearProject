import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomElevatedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Set the background color
          foregroundColor: Colors.white, // Set the text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 15), // Button padding
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16), // Text style (font size, weight, etc.)
        ),
      ),
    );
  }
}
