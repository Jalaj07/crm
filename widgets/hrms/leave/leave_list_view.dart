import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/hrms/leave_models.dart';
import 'leave_history_card.dart';

typedef LeaveRecordTapCallback = void Function(LeaveRecord leaveRecord);

class LeaveListView extends StatelessWidget {
  final List<LeaveRecord> leaveRecords;
  final DateFormat dateFormat;
  final LeaveRecordTapCallback onItemTap;
  final String currentFilter;

  const LeaveListView({
    super.key,
    required this.leaveRecords,
    required this.dateFormat,
    required this.onItemTap,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: leaveRecords.isEmpty
          ? Center(
              child: Text(
                'No $currentFilter leave requests found.',
                // Use TextTheme for styling
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withAlpha(153), // Slightly muted text
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: leaveRecords.length,
              itemBuilder: (context, index) {
                final leave = leaveRecords[index];
                // LeaveHistoryCard uses CardTheme now
                return LeaveHistoryCard(
                  leaveRecord: leave,
                  dateFormat: dateFormat,
                  onTap: () => onItemTap(leave),
                );
              },
            ),
    );
  }
}