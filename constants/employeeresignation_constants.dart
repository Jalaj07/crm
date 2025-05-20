// lib/features/resignation/presentation/constants.dart (example path)
import 'package:flutter/material.dart';

// Make the class public and rename it (e.g., AppConstants or ResignationConstants)
class ResignationConstants {
  // Prevent instantiation
  ResignationConstants._();

  // Status
  static const String statusDraft = 'Draft';
  static const String statusConfirmed = 'Confirmed';

  // Labels
  static const String labelEmployee = 'Employee';
  static const String labelDepartment = 'Department';
  static const String labelEmployeeContract = 'Employee Contract';
  static const String labelJoinDate = 'Join Date';
  static const String labelLastDay = 'Last Day of Employee';
  static const String labelApprovedLastDay = 'Approved Last Day Of Employee';
  static const String labelNoticePeriod = 'Notice Period (days)';
  static const String labelType = 'Type';
  static const String labelReason = 'Reason';

  // Hints
  static const String hintNoticePeriod = 'e.g., 30';

  // Validation Messages
  static const String validationSelectEmployee = 'Please select an employee';
  static const String validationEnterContract =
      'Please enter employee contract details';
  static const String validationSelectJoinDate = 'Please select join date';
  static const String validationSelectLastDay = 'Please select last day';
  static const String validationSelectApprovedLastDay =
      'Please select approved last day';
  static const String validationEnterNoticePeriod =
      'Please enter notice period';
  static const String validationValidNumber =
      'Please enter a valid positive number';
  static const String validationSelectType = 'Please select resignation type';
  static const String validationEnterReason =
      'Please enter the reason for resignation';
  static const String validationLastDayBeforeJoin =
      'Last day cannot be before join date';
  static const String validationApprovedLastDayBeforeJoin =
      'Approved last day cannot be before join date';
  // static const String validationApprovedLastDayVsLastDay = 'Approved last day cannot be before requested last day'; // Example

  // Button Labels
  static const String buttonCancel = 'Cancel';
  static const String buttonConfirm = 'Confirm';

  // Snackbar Messages
  static const String snackBarSuccess = 'Resignation submitted successfully!';
  static const String snackBarError = 'Please correct the errors in the form.';

  // Section Titles
  static const String titleEmployeeDetails = 'Employee Details';
  static const String titleDates = 'Dates';
  static const String titleResignationDetails = 'Resignation Details';

  // Spacing
  static const double formFieldSpacing = 20.0;
  static const double sectionSpacing = 30.0;

  // Common Input Decoration Helper (Moved here for potential wider use)
  static InputDecoration inputDecoration(
    String label, {
    IconData? suffixIcon,
    String? hintText,
    bool alignLabelWithHint = false,
    bool isEnabled = true,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 15.0,
      ),
      suffixIcon:
          suffixIcon != null
              ? Icon(
                suffixIcon,
                color: isEnabled ? Colors.grey[600] : Colors.grey[400],
              )
              : null,
      alignLabelWithHint: alignLabelWithHint,
      // Optional: Style label differently when disabled
      // labelStyle: TextStyle(color: isEnabled ? null : Colors.grey),
      // enabled: isEnabled, // Controls more than just appearance
    );
  }
}
