import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/hrms/leave_models.dart';
import 'leave_status_chip.dart'; // Ensure StatusChip also uses Theming

class LeaveHistoryCard extends StatelessWidget {
  final LeaveRecord leaveRecord;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const LeaveHistoryCard({
    super.key,
    required this.leaveRecord,
    required this.dateFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Use CardTheme defined centrally
    return Card(
      // Margin, Shape, Color, Elevation, Shadow handled by CardTheme
      child: InkWell( // Wrap content in InkWell for tap effect on Card
        borderRadius: BorderRadius.circular(10), // Match Card shape
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15), // Apply padding inside InkWell
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      '${dateFormat.format(leaveRecord.startDate)}–${dateFormat.format(leaveRecord.endDate)}',
                      // Use TextTheme
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // StatusChip should internally use theme colors based on status
                  StatusChip(status: leaveRecord.status),
                ],
              ),
              if (leaveRecord.additionalDates != null) ...[
                const SizedBox(height: 5),
                Text(
                  'Also: ${dateFormat.format(leaveRecord.additionalDates!.start)}–${dateFormat.format(leaveRecord.additionalDates!.end)}',
                  // Use TextTheme with a muted color
                  style: textTheme.bodyMedium?.copyWith(
                     color: colorScheme.onSurface.withAlpha(178),
                  ),
                ),
              ],
              const SizedBox(height: 5),
              Text(
                leaveRecord.leaveType,
                // Use TextTheme with a muted color
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha(178),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- IMPORTANT: leave_status_chip.dart must ALSO be updated to use theme colors ----
// Example snippet for StatusChip build method:
/*
@override
Widget build(BuildContext context) {
  final Color chipColor;
  final String label;
  final Color textColor;
  final colorScheme = Theme.of(context).colorScheme;

  switch (status) {
    case LeaveStatus.approved:
      // Use Primary or a success-like color derivable from theme
      chipColor = colorScheme.primary.withOpacity(0.1);
      textColor = colorScheme.primary;
      label = 'Approved';
      break;
    case LeaveStatus.pending:
      // Use Secondary or a warning-like color
      chipColor = colorScheme.secondary.withOpacity(0.1);
      textColor = colorScheme.secondary;
      label = 'Pending';
      break;
    case LeaveStatus.rejected:
      // Use Error color
      chipColor = colorScheme.error.withOpacity(0.1);
      textColor = colorScheme.error;
      label = 'Rejected';
      break;
    case LeaveStatus.none:
    default:
       // Use a neutral variant
       chipColor = colorScheme.surfaceVariant;
       textColor = colorScheme.onSurfaceVariant;
       label = 'Draft'; // Or None?
       break;
  }

  return Chip(
    label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
    backgroundColor: chipColor,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    labelPadding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    side: BorderSide.none,
  );
}
*/