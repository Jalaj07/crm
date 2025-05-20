import 'package:flutter/material.dart';
import 'package:flutter_development/utils/login_ui_helpers.dart'; // Adjust import

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged; // Callback to clear error in parent

  const EmailFieldWidget({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: buildInputDecoration(
        hint: 'Email or Phone',
        icon: Icons.alternate_email_outlined,
        errorText: errorText, // Pass error text to helper
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email or phone';
        }
        // Optional: Add more validation if needed
        return null;
      },
      onChanged: onChanged, // Call the callback
    );
  }
}
