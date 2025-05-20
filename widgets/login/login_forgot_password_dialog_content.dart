import 'package:flutter/material.dart';
import 'package:flutter_development/utils/login_ui_helpers.dart';

import '../../constants/login_constants.dart'; // Adjust import

// This widget contains the Form and actions for the dialog
class ForgotPasswordDialogContent extends StatefulWidget {
  final Function(String email) onSubmit;
  final bool isLoading; // New: pass loading state for the submit button

  const ForgotPasswordDialogContent({
    super.key,
    required this.onSubmit,
    required this.isLoading, // New
  });

  @override
  State<ForgotPasswordDialogContent> createState() =>
      _ForgotPasswordDialogContentState();
}

class _ForgotPasswordDialogContentState extends State<ForgotPasswordDialogContent> {
  final _dialogFormKey = GlobalKey<FormState>();
  final _forgotEmailController = TextEditingController();

  @override
  void dispose() {
    _forgotEmailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isLoading) return; // Don't submit if already loading
    if (_dialogFormKey.currentState!.validate()) {
      widget.onSubmit(_forgotEmailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column( // Removed Consumer<AuthProvider>
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _dialogFormKey,
          child: TextFormField(
            controller: _forgotEmailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: buildInputDecoration(
              hint: 'Enter your email',
              icon: Icons.email_outlined,
            ).copyWith(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 12.0,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: kSpacingLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: hintTextColor),
              onPressed: widget.isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: kSpacingSmall),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryBlue),
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: primaryBlue),
                    )
                  : const Text(
                      'Send Request',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}