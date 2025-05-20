import 'package:flutter/material.dart';
import 'package:flutter_development/utils/login_ui_helpers.dart';
import '../../constants/login_constants.dart'; // Adjust import

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? errorText;
  final ValueChanged<String>? onChanged; // Callback to clear error in parent
  final VoidCallback? onSubmitted; // Callback for form submission

  const PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: buildInputDecoration(
        hint: 'Password',
        icon: Icons.lock_outline,
        errorText: errorText, // Pass error text
        suffixIcon: IconButton(
          // Pass suffix icon to helper
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: hintTextColor,
            size: 20,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onChanged: onChanged, // Call the callback
      onFieldSubmitted: (_) => onSubmitted?.call(), // Call the callback
    );
  }
}
