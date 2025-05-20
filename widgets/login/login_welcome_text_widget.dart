import 'package:flutter/material.dart';
import '../../constants/login_constants.dart'; // Adjust import

class WelcomeTextWidget extends StatelessWidget {
  const WelcomeTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Welcome User!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: darkTextColor,
          ),
        ),
        SizedBox(height: kSpacingSmall),
        Text(
          'Enter your credentials to login',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: hintTextColor),
        ),
      ],
    );
  }
}
