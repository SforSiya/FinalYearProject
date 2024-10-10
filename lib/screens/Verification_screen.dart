import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/Phone_Auth.dart';
import '../widgets/CustomElevatedButton.dart';
import 'ResetPassword_screen.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  void _submitVerificationCode() {
    String code = _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text;

    if (code.length != 4) {
      // Show an alert dialog if the code is incomplete
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter the complete verification code.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Use the combined code to verify
      _phoneAuthService.verifyCode(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter verification code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeInput(_controller1),
                _buildCodeInput(_controller2),
                _buildCodeInput(_controller3),
                _buildCodeInput(_controller4),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "If you didn't receive a code, ",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            GestureDetector(
              onTap: () {
                // Add resend code logic here
                print('Resend code tapped');
              },
              child: Text(
                "Resend",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            SizedBox(height: 30),
            CustomElevatedButton(
              text: 'Send',
              onTap: _submitVerificationCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(TextEditingController controller) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
