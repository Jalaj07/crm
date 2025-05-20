import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/hrms/leave_models.dart'; // Adjust import path if necessary

// Define a type alias for the callback
typedef EditLeaveUpdateCallback = void Function(LeaveRecord updatedRecord);

class EditLeaveSheetContent extends StatefulWidget {
  final LeaveRecord originalLeaveRecord;
  final EditLeaveUpdateCallback onUpdate;
  final DateFormat dateFormat;

  const EditLeaveSheetContent({
    super.key,
    required this.originalLeaveRecord,
    required this.onUpdate,
    required this.dateFormat,
  });

  @override
  State<EditLeaveSheetContent> createState() => _EditLeaveSheetContentState();
}

class _EditLeaveSheetContentState extends State<EditLeaveSheetContent> {
  late DateTime startDate; // Use non-nullable since initialized from original
  late DateTime endDate;   // Use non-nullable
  late String leaveType;
  late String reason;
  String? errorMessage;

  late final TextEditingController _reasonController;
  // Consider fetching these types from a central source or constants file
  final leaveTypes = ['Annual Leave', 'Sick Leave', 'Casual Leave', 'Vacation', 'Unpaid Leave'];

  @override
  void initState() {
    super.initState();
    // Initialize state from the original record passed in the constructor
    startDate = widget.originalLeaveRecord.startDate;
    endDate = widget.originalLeaveRecord.endDate;
    leaveType = widget.originalLeaveRecord.leaveType;
    reason = widget.originalLeaveRecord.reason ?? ''; // Handle potential null reason
    _reasonController = TextEditingController(text: reason);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _tryUpdate() {
    // Validation (start/end date cannot be null here due to initialization)
    if (endDate.isBefore(startDate)) {
      setState(() { errorMessage = 'End date cannot be before start date.'; });
      return;
    }

    // Create the UPDATED record instance
    final updatedRecord = LeaveRecord(
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason.isEmpty ? null : reason, // Update reason
      status: LeaveStatus.pending, // Edits usually revert status to pending for re-approval
      // Preserve existing additional dates if applicable to your model
      additionalDates: widget.originalLeaveRecord.additionalDates,
    );

    // Use the onUpdate callback passed from LeaveScreen
    widget.onUpdate(updatedRecord);
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
      child: SingleChildScrollView( // Allow scrolling
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Leave Request', // Updated Title
              style: textTheme.titleLarge, // Use theme text style
            ),
            const SizedBox(height: 20),

            // --- Form Fields ---
            // Dropdown uses InputDecorator theme indirectly
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Leave Type'),
              value: leaveType, // Pre-filled value
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
                 // Pass context and pre-fill based on initialized state
                Expanded(child: _buildDatePicker(context, isStart: true)),
                const SizedBox(width: 10),
                 // Pass context and pre-fill based on initialized state
                Expanded(child: _buildDatePicker(context, isStart: false)),
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
              controller: _reasonController, // Pre-filled via controller
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'Enter reason for leave',
              ),
              maxLines: 3,
              onChanged: (value) { reason = value.trim(); },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 15),

            // Display calculated duration (always available as dates are non-null)
            Text(
              'Number of days: ${endDate.difference(startDate).inDays + 1}',
              // Use theme text style
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // --- Update Button ---
            // ElevatedButton uses ElevatedButtonThemeData
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _tryUpdate, // Always enabled as fields are pre-filled (unless date range is invalid)
                child: const Text('Update Request'), // Updated Button Text
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Date Picker method (Shared logic with Apply) ---
   Widget _buildDatePicker(BuildContext context, {required bool isStart}) {
     final theme = Theme.of(context);
     final textTheme = theme.textTheme;
     final colorScheme = theme.colorScheme;
     // currentValue is guaranteed non-null because it's initialized in initState
     final DateTime currentValue = isStart ? startDate : endDate;
     final String label = isStart ? 'Start Date' : 'End Date';

     // Policy for editing past dates needs consideration.
     // For simplicity, allowing edits starting from 'today' unless original date was in the future.
     final now = DateTime.now();
     final today = DateTime(now.year, now.month, now.day);
     final DateTime firstAllowedDate;
     if (isStart) {
       // Allow selecting original past start date? Or force from today? Force today:
       firstAllowedDate = today;
     } else {
        // End date must be >= start date (which might be today or future)
        firstAllowedDate = (startDate.isAfter(today)) ? startDate : today;
     }


    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: currentValue, // Start picker at the current value
          firstDate: firstAllowedDate, // Apply policy
          lastDate: today.add(const Duration(days: 365)), // Example limit
        );
        if (picked != null && picked != currentValue) {
          setState(() {
            if (isStart) {
              startDate = picked;
              // Ensure end date remains valid after start date change
              if (endDate.isBefore(startDate)) {
                endDate = startDate; // Default end date to new start date if invalid
              }
            } else {
              endDate = picked;
            }
             // Validate date range after update
            if (endDate.isBefore(startDate)) {
              errorMessage = 'End date cannot be before start date.';
            } else {
              errorMessage = null; // Clear error if valid
            }
          });
        }
      },
      child: InputDecorator(
        // Uses InputDecorationTheme
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(Icons.calendar_today, size: 18, color: theme.inputDecorationTheme.suffixIconColor),
        ),
        child: Text(
          // currentValue is always non-null here
          widget.dateFormat.format(currentValue),
          style: textTheme.bodyLarge?.copyWith( // Use theme style
             // Color should always be the default text color as value exists
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}