import 'package:flutter/material.dart';
import '../../constants/login_constants.dart'; // Adjust import

class ForgotPasswordButtonWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const ForgotPasswordButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kSpacingSmall,
        bottom: kSpacingMedium,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: isLoading ? null : onPressed, // Use isLoading state
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            minimumSize: const Size(50, 30),
            alignment: Alignment.centerRight,
            foregroundColor: primaryBlue,
          ),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
