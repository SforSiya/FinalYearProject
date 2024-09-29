import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/ResetPassword_screen.dart';
import '../screens/Verification_screen.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();

  String? verificationId;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException authException) {
      print(authException.message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification failed. Please try again.')),
      );
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      this.verificationId = verificationId;
      // Navigate to the verification code screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerificationScreen()),
      );
    }

    codeAutoRetrievalTimeout(String verificationId) {
      this.verificationId = verificationId;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print("Failed to Verify Phone Number: $e");
    }
  }

  Future<void> verifyCode(BuildContext context, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    } catch (e) {
      print("Failed to sign in with code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid verification code. Please try again.')),
      );
    }
  }
}
