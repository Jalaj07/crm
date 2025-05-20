import 'package:flutter/material.dart';
import '../../constants/login_constants.dart'; // Adjust import

class LoginButtonWidget extends StatelessWidget {
  final VoidCallback? onLogin;
  final bool isAnyLoading; // Use the combined loading state

  const LoginButtonWidget({
    super.key,
    required this.onLogin,
    required this.isAnyLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to provider for specific loading state if needed,
    // but disabling is based on the combined state passed in.
     if (isAnyLoading) { // Show loader directly if any loading is true
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: primaryBlue,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: onLogin, // Already guarded by isAnyLoading in the parent condition
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
            shadowColor: primaryBlue.withAlpha(102),
          ),
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}