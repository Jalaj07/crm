import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/hrms/leave_models.dart'; // Adjust import path if necessary

// Define a type alias for the callback
typedef ApplyLeaveSubmitCallback = void Function(LeaveRecord newRecord);

class ApplyLeaveSheetContent extends StatefulWidget {
  final ApplyLeaveSubmitCallback onSubmit;
  final DateFormat dateFormat; // Pass DateFormat if needed inside

  const ApplyLeaveSheetContent({
    super.key,
    required this.onSubmit,
    required this.dateFormat, // Or initialize it here if always the same
  });

  @override
  State<ApplyLeaveSheetContent> createState() => _ApplyLeaveSheetContentState();
}

class _ApplyLeaveSheetContentState extends State<ApplyLeaveSheetContent> {
  DateTime? startDate;
  DateTime? endDate;
  String leaveType = 'Annual Leave'; // Default value
  String reason = '';
  String? errorMessage; // To show date validation errors

  final _reasonController = TextEditingController();
  // Consider fetching these types from a central source or constants file
  final leaveTypes = ['Annual Leave', 'Sick Leave', 'Casual Leave', 'Vacation', 'Unpaid Leave'];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _trySubmit() {
    // Basic validation
    if (startDate == null || endDate == null) {
      setState(() { errorMessage = 'Please select both start and end dates.'; });
      return;
    }
    if (endDate!.isBefore(startDate!)) {
      setState(() { errorMessage = 'End date cannot be before start date.'; });
      return; // Stop submission
    }

    final newRecord = LeaveRecord(
      leaveType: leaveType,
      startDate: startDate!,
      endDate: endDate!,
      reason: reason.isEmpty ? null : reason, // Store null if empty
      status: LeaveStatus.pending, // New requests are always pending
      additionalDates: null, // No additional dates on apply screen usually
    );

    // Use the callback passed from LeaveScreen
    widget.onSubmit(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    // Access theme data for text styles and specific colors if needed
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Padding includes viewInsets automatically for keyboard avoidance
    // BottomSheetThemeData handles background/shape
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView( // Allow scrolling if content overflows
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Apply for Leave',
              style: textTheme.titleLarge, // Use theme text style
            ),
            const SizedBox(height: 20),

            // --- Form Fields ---
            // Dropdown uses InputDecorator theme indirectly
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Leave Type',
                // Other styles like border, padding come from InputDecorationTheme
              ),
              value: leaveType,
              items: leaveTypes.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() { leaveType = newValue; });
                }
              },
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(child: _buildDatePicker(context, isStart: true)), // Pass context
                const SizedBox(width: 10),
                Expanded(child: _buildDatePicker(context, isStart: false)), // Pass context
              ],
            ),
            // Show date validation error message
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  errorMessage!,
                   // Use theme text style and error color
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                ),
              ),
            ],
            const SizedBox(height: 15),

            // TextField uses InputDecorationTheme
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'Enter reason for leave',
                // Other styles from theme
              ),
              maxLines: 3,
              onChanged: (value) { reason = value.trim(); },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 15),

            // Display calculated duration
            if (startDate != null && endDate != null && !endDate!.isBefore(startDate!)) ...[
              Text(
                'Number of days: ${endDate!.difference(startDate!).inDays + 1}',
                 // Use theme text style
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
            ],

            // --- Submit Button ---
            // ElevatedButton uses ElevatedButtonThemeData
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (startDate != null && endDate != null) ? _trySubmit : null, // Enable only when dates are valid
                child: const Text('Submit Request'),
              ),
            ),
            const SizedBox(height: 20), // Padding at the bottom
          ],
        ),
      ),
    );
  }

  // --- Helper method for date pickers ---
  Widget _buildDatePicker(BuildContext context, {required bool isStart}) {
     final theme = Theme.of(context); // Need context for theme
     final textTheme = theme.textTheme;
     final colorScheme = theme.colorScheme;
     final bool isEnabled = isStart || startDate != null; // Enable end date only if start date is set
     final DateTime? currentValue = isStart ? startDate : endDate;
     final String label = isStart ? 'Start Date' : 'End Date';

     final now = DateTime.now();
     final today = DateTime(now.year, now.month, now.day);
     // For start date, first allowed date is today.
     // For end date, first allowed date is the selected start date (or today if start date is not set or before today).
     final DateTime firstAllowedDate = isStart
        ? today
        : (startDate != null && startDate!.isAfter(today) ? startDate! : today);


    return InkWell(
      onTap: !isEnabled ? null : () async { // Disable tap if needed
        final picked = await showDatePicker(
          context: context,
          initialDate: currentValue ?? startDate ?? today,
          firstDate: firstAllowedDate,
          lastDate: today.add(const Duration(days: 365)), // Example limit
        );
        if (picked != null && picked != currentValue) {
          setState(() {
            if (isStart) {
              startDate = picked;
              // Reset end date if it becomes invalid
              if (endDate != null && endDate!.isBefore(startDate!)) { endDate = null; }
            } else {
              endDate = picked;
            }
             // Clear error if the picked date makes the range valid or potentially valid
            if (startDate != null && endDate != null && !endDate!.isBefore(startDate!)) {
               errorMessage = null;
            } else if (startDate != null && endDate != null && endDate!.isBefore(startDate!)){
               errorMessage = 'End date cannot be before start date.';
            } else {
              errorMessage = null; // Clear partial errors too
            }
          });
        }
      },
      // InputDecorator uses InputDecorationTheme
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          // Icon styling might be needed if not covered by suffixIconColor in theme
           suffixIcon: Icon(Icons.calendar_today, size: 18, color: theme.inputDecorationTheme.suffixIconColor),
        ),
        child: Text(
          currentValue != null ? widget.dateFormat.format(currentValue) : 'Select date',
          style: textTheme.bodyLarge?.copyWith( // Base style from theme
             // Use a muted color if empty or disabled
            color: currentValue != null && isEnabled ? colorScheme.onSurface : colorScheme.onSurface.withAlpha(153),
             // Indicate disabled state visually
            decoration: !isEnabled ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}