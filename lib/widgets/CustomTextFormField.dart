import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;

  CustomTextFormField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: obscureText
            ? IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onVisibilityToggle,
        )
            : null,
      ),
      obscureText: obscureText && !isPasswordVisible,
      validator: validator,
    );
  }
}
