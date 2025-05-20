// lib/features/resignation/presentation/widgets/action_buttons_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/constants/employeeresignation_constants.dart';

class ActionButtonsSection extends StatelessWidget {
  final bool isDraft;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const ActionButtonsSection({
    super.key,
    required this.isDraft,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onCancel, // Always enabled
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(ResignationConstants.buttonCancel),
          ),
        ),
        const SizedBox(width: ResignationConstants.formFieldSpacing),
        Expanded(
          child: ElevatedButton(
            onPressed: isDraft ? onSubmit : null, // Enabled only if draft
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.blueAccent.withAlpha(127),
              disabledForegroundColor: Colors.white.withAlpha(178),
            ),
            child: const Text(ResignationConstants.buttonConfirm),
          ),
        ),
      ],
    );
  }
}
