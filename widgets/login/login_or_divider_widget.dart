// lib/widgets/login/login_or_divider_widget.dart
import 'package:flutter/material.dart';
import '../../constants/login_constants.dart'; // Adjust import

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget can be shown if quick login options might be present,
    // or simply always shown between quick login and manual login.
    // For now, making it static. It can be conditionally rendered in LoginScreen if needed.
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacingMedium),
      child: Row(
        children: [
          Expanded(child: Divider(color: borderColor.withAlpha(178))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kSpacingMedium),
            child: Text(
              "OR",
              style: TextStyle(
                color: hintTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: borderColor.withAlpha(178))),
        ],
      ),
    );
  }
}