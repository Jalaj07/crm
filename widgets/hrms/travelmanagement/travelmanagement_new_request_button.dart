// lib/widgets/hrms/travelmanagement/travelmanagement_new_request_button.dart
import 'package:flutter/material.dart';

class NewRequestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label; // MODIFIED: Added label parameter
  final IconData icon;  // MODIFIED: Added icon parameter

  const NewRequestButton({
    super.key,
    required this.onPressed,
    this.label = 'New Request', // MODIFIED: Provide a default or make it required
    this.icon = Icons.add,       // MODIFIED: Provide a default or make it required
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon), // MODIFIED: Use the passed icon
        label: Text(label), // MODIFIED: Use the passed label
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}