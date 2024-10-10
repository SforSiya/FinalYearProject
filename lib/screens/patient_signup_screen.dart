import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathmind/screens/patient_signup_screen.dart';
import 'package:mathmind/screens/signup_screen.dart';
import '../helper/auth_service.dart';

class ParentRegistrationScreen extends StatefulWidget {
  @override
  _ParentRegistrationScreenState createState() => _ParentRegistrationScreenState();
}

class _ParentRegistrationScreenState extends State<ParentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerParent() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final authService = AuthService();
        final user = await authService.signUpParent(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientRegistrationScreen(parentEmail: _emailController.text),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _showEmailAlreadyInUseDialog();
        } else {
          _showErrorDialog(e.message);
        }
      }
    }
  }

  void _showEmailAlreadyInUseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Email Already in Use'),
        content: Text('The email address is already in use by another account. Please try logging in instead.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String? message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Up Failed'),
        content: Text(message ?? 'An unknown error occurred. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerParent,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}































