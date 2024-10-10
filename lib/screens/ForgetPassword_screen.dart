import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../widgets/CustomElevatedButton.dart';
import '../widgets/CustomTextFormField.dart';
import 'ResetPassword_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? verificationId;
  bool isCodeSent = false;
  bool isResending = false;
  int _resendCooldown = 0;
  Timer? _timer;

  // Start the cooldown timer for resending the verification code
  void _startResendCooldown() {
    _resendCooldown = 60; // Cooldown for 60 seconds
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendCode() async {
    final phone = phoneController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isResending = true;
      });

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieval
            await FirebaseAuth.instance.signInWithCredential(credential);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordScreen()));
          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle error
            String errorMessage;
            if (e.code == 'invalid-phone-number') {
              errorMessage = 'The phone number entered is invalid.';
            } else {
              errorMessage = e.message ?? 'Verification failed. Please try again.';
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              this.verificationId = verificationId;
              isCodeSent = true;
              isResending = false;
            });
            _startResendCooldown();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId = verificationId;
          },
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        setState(() {
          isResending = false;
        });
      }
    }
  }

  Future<void> _verifyCode(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordScreen()));
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter your phone number to receive a verification code.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: phoneController,
                  obscureText: false,
                  hintText: 'Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(value)) {
                      return 'Please enter a valid phone number with country code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                if (isCodeSent)
                  Text(
                    'A verification code has been sent to your phone number. Please enter it below.',
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                CustomElevatedButton(
                  text: isCodeSent ? 'Verify Code' : 'Send Code',
                  onTap: () {
                    if (isCodeSent) {
                      // Code to verify SMS code
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Enter Verification Code'),
                          content: TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            onChanged: (value) {
                              if (value.length == 6) {
                                _verifyCode(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      );
                    } else {
                      _sendCode();
                    }
                  },
                ),
                if (isCodeSent && _resendCooldown > 0)
                  Text(
                    'You can resend the code in $_resendCooldown seconds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                if (isCodeSent && _resendCooldown == 0)
                  CustomElevatedButton(
                    text: 'Resend Code',
                    onTap: _sendCode,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
