import 'package:flutter/material.dart';

class LeaveBalanceSheetContent extends StatelessWidget {
  final Map<String, int> balanceBreakdown;

  const LeaveBalanceSheetContent({super.key, required this.balanceBreakdown});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final int totalCalculated = balanceBreakdown.values.fold(0, (sum, item) => sum + item);

    // BottomSheet background/shape is handled by theme
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leave Balance Details',
            style: textTheme.titleLarge, // Use TextTheme
          ),
          const SizedBox(height: 20),
          ...balanceBreakdown.entries.map(
            (entry) => _buildLeaveBalanceItem(context, entry.key, entry.value),
          ),
          const Divider(height: 30), // Uses DividerThemeData
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Available:',
                // Use TextTheme, make bold
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '$totalCalculated Days',
                // Use TextTheme, make bold, use primary color for accent
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceItem(BuildContext context, String leaveType, int days) {
     final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leaveType,
            style: textTheme.bodyLarge, // Use TextTheme
          ),
          Text(
            '$days Days',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500), // Use TextTheme
          ),
        ],
      ),
    );
  }
}