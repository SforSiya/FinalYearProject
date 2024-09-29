import 'package:flutter/material.dart';
import '../helper/auth_service.dart';
import '../widgets/CustomElevatedButton.dart';
import '../widgets/CustomTextFormField.dart';

import 'login_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final String parentEmail;

  const PatientRegistrationScreen({super.key, required this.parentEmail});

  @override
  _PatientRegistrationScreenState createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _parentEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _registerPatient() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = AuthService();
      final user = await authService.signUpPatient(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        widget.parentEmail,
      );

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Handle the error (e.g., show a Snackbar or dialog)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _parentEmailController,
                    hintText: 'Parent Email',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the parent\'s email';
                      }
                      if (value != widget.parentEmail) {
                        return 'Parent email does not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: !_obscurePassword,
                    isPasswordVisible: !_obscurePassword,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: !_obscureConfirmPassword,
                    isPasswordVisible: !_obscureConfirmPassword,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    onTap: _registerPatient,
                    text: 'Register',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
