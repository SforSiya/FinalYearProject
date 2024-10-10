import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/CustomElevatedButton.dart';
import '../widgets/CustomTextFormField.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ResetPasswordDone_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(_newPasswordController.text.trim());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PasswordUpdatedScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user is signed in currently.')));
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _newPasswordController,
                hintText: 'New Password',
                obscureText: !_isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: !_isConfirmPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              CustomElevatedButton(
                text: 'Reset Password',
                onTap: _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
