import 'package:flutter/material.dart'; // Needed for Color

class AppConstants {
  static const List<String> ideaCategories = [
    'Process Improvement',
    'Employee Welfare',
    'Hiring Process',
    'Technology Implementation',
    'Cost Reduction',
    'Customer Experience',
    'Sustainability',
    'Other',
  ];
  static const String statusPending = 'Pending';
  static const String statusUnderReview = 'Under Review';
  static const String statusApproved = 'Approved';
  static const String statusImplemented = 'Implemented';
  static const String statusRejected = 'Rejected';
  static final Map<String, Color> statusColors = {
    statusPending: Colors.orange.shade700,
    statusUnderReview: Colors.blue.shade600,
    statusApproved: Colors.green.shade600,
    statusImplemented: Colors.purple.shade400,
    statusRejected: Colors.red.shade600,
  };
  static Color getStatusColor(String status) =>
      statusColors[status] ?? Colors.grey.shade600;
  static const double screenPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double itemSpacing = 8.0;
  static const double sectionSpacing = 16.0;
  static const double largeSectionSpacing = 24.0;
  static const double borderRadius = 12.0;
}
