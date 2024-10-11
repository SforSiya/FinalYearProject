import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for FirebaseAuth and UserCredential
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore
import 'package:mathmind/screens/patient_signup_screen.dart';
import '../helper/auth_service.dart';
import '../widgets/CustomElevatedButton.dart';
import '../widgets/CustomTextFormField.dart';
import 'ForgetPassword_screen.dart';
import 'Parent_Home.dart';
import '../patient/Patient_Home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? _selectedRole;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Parent login logic
  Future<void> _parentLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Authenticate parent
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = result.user;
        if (user != null) {
          // Check if the user is a registered parent (Guardian) in Firestore
          DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists && userDoc['role'] == 'Guardian') {
            // Fetch children data associated with the parent
            AuthService authService = AuthService();
            List<Map<String, dynamic>> childrenData =
            await authService.fetchParentChildrenData(_emailController.text);

            // Navigate to Parent Home, passing the children's data
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ParentHome()),
            );
          } else {
            _showError("No parent account found with this email.");
          }
        }
      } on FirebaseAuthException catch (e) {
        _showError(e.message);
      }
    }
  }

  // Patient login logic
  Future<void> _patientLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Authenticate patient
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = result.user;
        if (user != null) {
          // Check if the user is a registered patient in Firestore
          DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists && userDoc['role'] == 'Patient') {
            // Verify that the patient's parentEmail matches a registered parent
            String parentEmail = userDoc['parentEmail'];
            QuerySnapshot parentSnapshot = await _firestore
                .collection('users')
                .where('email', isEqualTo: parentEmail)
                .where('role', isEqualTo: 'Guardian')
                .get();

            if (parentSnapshot.docs.isNotEmpty) {
              // Navigate to Patient Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientHome()),
              );
            } else {
              _showError("No parent account associated with this patient.");
            }
          } else {
            // If user role is not 'Patient'
            _showError("No patient account found with this email.");
          }
        }
      } on FirebaseAuthException catch (e) {
        // Firebase Authentication error
        _showError(e.message);
      }
    }
  }

  // Handle login based on role
  Future<void> _login() async {
    if (_selectedRole == 'Guardian') {
      _parentLogin(); // Call parent login logic
    } else if (_selectedRole == 'Patient') {
      _patientLogin(); // Call patient login logic
    } else {
      _showError("Please select a role.");
    }
  }

  // Display error messages
  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'An error occurred')),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.08),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomTextFormField(
                    controller: _emailController,
                    obscureText: false,
                    hintText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: !_isPasswordVisible,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Patient',
                        child: Text('Patient'),
                      ),
                      DropdownMenuItem(
                        value: 'Guardian',
                        child: Text('Guardian'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a role';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text("Forget Password?"),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomElevatedButton(
                    text: 'LOGIN',
                    onTap: _login, // Call the login method
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ParentRegistrationScreen()),
                      );
                    },
                    child: Text("Don't have an account? Sign up"),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
