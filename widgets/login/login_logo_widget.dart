import 'package:flutter/material.dart';
import '../../constants/login_constants.dart'; // Adjust import

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacingLarge),
      child: Image.asset(
        'assets/images/company_logo.png', // Ensure this asset exists
        height: 50,
        errorBuilder:
            (context, error, stackTrace) => const Icon(
              Icons.business_center,
              size: 50,
              color: darkTextColor,
            ),
      ),
    );
  }
}
