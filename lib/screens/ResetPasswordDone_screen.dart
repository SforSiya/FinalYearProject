import 'package:flutter/material.dart';
import '../widgets/CustomElevatedButton.dart';
import 'login_screen.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.8;

    return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 100,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          'Password Updated',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Your password has been successfully updated',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Container(
          width: containerWidth,
          child: CustomElevatedButton(
            text: 'Sign In',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              // Navigate to the sign-in screen or perform another action
              print('Sign In button pressed');
              },
          ),
        ),
      ],
    ),
    ),
    ),
    );
  }
}


