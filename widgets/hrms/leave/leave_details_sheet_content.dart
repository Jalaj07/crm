import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/hrms/leave_models.dart';
import 'leave_status_chip.dart'; // Assumes this is themed

class LeaveDetailsSheetContent extends StatelessWidget {
  final LeaveRecord leaveRecord;
  final DateFormat dateFormat;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;

  const LeaveDetailsSheetContent({
    super.key,
    required this.leaveRecord,
    required this.dateFormat,
    this.onEdit,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    bool showActionButtons = leaveRecord.status == LeaveStatus.pending && onEdit != null && onCancel != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + (showActionButtons ? 20 : 30),
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  leaveRecord.leaveType,
                  style: textTheme.titleLarge, // Use TextTheme
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(status: leaveRecord.status),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailItem( context, 'Date Range', '${dateFormat.format(leaveRecord.startDate)} - ${dateFormat.format(leaveRecord.endDate)}'),
          if (leaveRecord.additionalDates != null) ...[
            const SizedBox(height: 15),
            _buildDetailItem(context,'Additional Dates', '${dateFormat.format(leaveRecord.additionalDates!.start)} - ${dateFormat.format(leaveRecord.additionalDates!.end)}'),
          ],
          const SizedBox(height: 15),
          _buildDetailItem( context, 'Reason', leaveRecord.reason?.isNotEmpty == true ? leaveRecord.reason! : 'No reason provided',),
          if (showActionButtons) ...[
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  // OutlinedButton styling inherited from theme, except error color
                  child: OutlinedButton(
                    onPressed: onCancel,
                    // Specific error styling for this button
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                      // Keep padding/shape from theme unless needing override
                    ),
                    child: const Text('Cancel Request'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // ElevatedButton uses ElevatedButtonTheme
                  child: ElevatedButton(
                    onPressed: onEdit,
                    child: const Text('Edit Request'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
     final textTheme = Theme.of(context).textTheme;
     final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          // Use TextTheme and slightly muted color
          style: textTheme.labelLarge?.copyWith(
             color: colorScheme.onSurface.withAlpha(178),
          ),
        ),
        const SizedBox(height: 4),
        // Use TextTheme
        Text(value, style: textTheme.bodyLarge),
      ],
    );
  }
}