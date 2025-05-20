// lib/models/hrms/myexpenses/myexpenses_status.dart
import 'package:flutter/material.dart';
// Ensure this path is correct and it's the file with StatusColors from the start of chat
import 'package:flutter_development/theme/central_app_theme_color.dart';

enum ExpenseStatus { submitted, approved, paid, refused }

extension ExpenseStatusInfo on ExpenseStatus {
  Color getColor(BuildContext context) {
    final statusTheme = Theme.of(context).extension<StatusColors>();
    // Fallback if theme extension is somehow not found
    if (statusTheme == null) return Colors.grey.shade700;

    switch (this) {
      case ExpenseStatus.submitted:
        // Map 'submitted' expense status to the visual of 'pending' travel status
        return statusTheme.pending ?? Colors.orange; // Default if 'pending' is null
      case ExpenseStatus.approved:
        // 'approved' is likely a shared concept
        return statusTheme.approved ?? Colors.green;
      case ExpenseStatus.paid:
        // Map 'paid' to the visual of 'completed' travel status
        return statusTheme.completed ?? Colors.blue; // Or inProgress if visually better
      case ExpenseStatus.refused:
        // There might not be a direct 'refused' in travel, so use 'defaultStatus' or 'error'
        // For Travel Management, error was theme.colorScheme.error.
        // If you want it to match a generic 'defaultStatus' look from StatusColors:
        return statusTheme.defaultStatus ?? Theme.of(context).colorScheme.error;
    }
  }

  String get displayName {
    switch (this) {
      case ExpenseStatus.submitted: return 'Pending'; // Or 'Submitted'
      case ExpenseStatus.approved:  return 'Approved';
      case ExpenseStatus.paid:      return 'Paid';
      case ExpenseStatus.refused:   return 'Refused';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseStatus.submitted: return Icons.hourglass_top_rounded; // Or Icons.pending_actions_outlined
      case ExpenseStatus.approved:  return Icons.check_circle_outline_rounded;
      case ExpenseStatus.paid:      return Icons.paid_outlined; // Or Icons.done_all_rounded if 'completed'
      case ExpenseStatus.refused:   return Icons.cancel_outlined; // Or Icons.block_flipped
    }
  }

  Color getBackgroundColor(BuildContext context) {
    final statusTheme = Theme.of(context).extension<StatusColors>();
    if (statusTheme == null) return Colors.grey.withAlpha(30);

    switch (this) {
      case ExpenseStatus.submitted:
        return statusTheme.pendingBackground ?? Colors.orange.withAlpha(38);
      case ExpenseStatus.approved:
        return statusTheme.approvedBackground ?? Colors.green.withAlpha(38);
      case ExpenseStatus.paid:
        return statusTheme.completedBackground ?? Colors.blue.withAlpha(38);
      case ExpenseStatus.refused:
        return statusTheme.defaultStatusBackground ?? Theme.of(context).colorScheme.error.withAlpha(38);
    }
  }
}