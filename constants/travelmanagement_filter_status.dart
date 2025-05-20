// lib/constants/travelmanagement_filter_status.dart
import 'package:flutter/material.dart';
// Assuming StatusColors is in 'your_app_path/theme/theme_controller.dart'
import '../theme/central_app_theme_color.dart'; // Replace with actual path to your StatusColors definition

class FilterStatus {
  FilterStatus._(); // Prevent instantiation

  static const String all = 'All';
  static const String pending = 'Pending';
  static const String approved = 'Approved';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';

  static const List<String> values = [
    all,
    pending,
    approved,
    inProgress,
    completed,
  ];

  // Helper method to get color based on status, using themed StatusColors
  static Color getColor(String status, StatusColors statusTheme) {
    switch (status) {
      case approved:
        return statusTheme.approved ?? statusTheme.defaultStatus ?? Colors.grey;
      case pending:
        return statusTheme.pending ?? statusTheme.defaultStatus ?? Colors.grey;
      case inProgress:
        return statusTheme.inProgress ??
            statusTheme.defaultStatus ??
            Colors.grey;
      case completed:
        return statusTheme.completed ??
            statusTheme.defaultStatus ??
            Colors.grey;
      default:
        return statusTheme.defaultStatus ??
            Colors.grey; // Fallback for 'All' or unknown
    }
  }

  // Helper for background color variants, using themed StatusColors
  static Color getBackgroundColor(String status, StatusColors statusTheme) {
    switch (status) {
      case approved:
        return statusTheme.approvedBackground ??
            statusTheme.defaultStatusBackground ??
            Colors.grey.withAlpha(30);
      case pending:
        return statusTheme.pendingBackground ??
            statusTheme.defaultStatusBackground ??
            Colors.grey.withAlpha(30);
      case inProgress:
        return statusTheme.inProgressBackground ??
            statusTheme.defaultStatusBackground ??
            Colors.grey.withAlpha(30);
      case completed:
        return statusTheme.completedBackground ??
            statusTheme.defaultStatusBackground ??
            Colors.grey.withAlpha(30);
      default:
        return statusTheme.defaultStatusBackground ??
            Colors.grey.withAlpha(20); // Fallback
    }
  }
}
