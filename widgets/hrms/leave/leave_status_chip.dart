import 'package:flutter/material.dart';
import '../../../models/hrms/leave_models.dart'; // Import the models

class StatusChip extends StatelessWidget {
  final LeaveStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == LeaveStatus.none) {
      return const SizedBox.shrink(); // Use SizedBox.shrink() for empty widgets
    }

    Color color;
    String text;

    switch (status) {
      case LeaveStatus.approved:
        color = Colors.green;
        text = 'Approved';
        break;
      case LeaveStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case LeaveStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
      default: // Includes LeaveStatus.none although handled above
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
