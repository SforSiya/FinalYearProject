import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;

  CustomTextFormField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    this.validator,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        hintText: hintText,
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
