// await prefs.setString('last_logged_in_email', username); // When logging in with username/email

// lib/widgets/login/quick_login_section_widget.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // To get last email
import '../../constants/login_constants.dart'; // Adjust import

class QuickLoginSectionWidget extends StatefulWidget {
  final VoidCallback? onQuickLogin;
  final bool isQuickLoginLoading; // Specific loading state for this button

  const QuickLoginSectionWidget({
    super.key,
    required this.onQuickLogin,
    required this.isQuickLoginLoading,
  });

  @override
  State<QuickLoginSectionWidget> createState() => _QuickLoginSectionWidgetState();
}

class _QuickLoginSectionWidgetState extends State<QuickLoginSectionWidget> {
  String? _lastEmail;

  @override
  void initState() {
    super.initState();
    _loadLastEmail();
  }

  Future<void> _loadLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _lastEmail = prefs.getString('last_logged_in_email');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isQuickLoginLoading) { // If quick login is processing
      return Padding(
        padding: const EdgeInsets.only(bottom: kSpacingMedium),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: primaryBlue,
              ),
            ),
          ),
        ),
      );
    }

    if (_lastEmail != null) { // If not loading and last email exists
      return Padding(
        padding: const EdgeInsets.only(bottom: kSpacingMedium),
        child: OutlinedButton.icon(
          icon: const Icon(Icons.account_circle_outlined, size: 20),
          label: Text(
            'Login as $_lastEmail',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: widget.onQuickLogin, // Loading is handled by the condition above
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryBlue,
            side: const BorderSide(color: primaryBlue),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      );
    } else { // No last email, and not loading quick login
      return const SizedBox.shrink();
    }
  }
}