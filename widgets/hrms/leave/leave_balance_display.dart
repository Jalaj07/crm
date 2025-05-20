import 'package:flutter/material.dart';

class LeaveBalanceDisplay extends StatelessWidget {
  final int leaveBalance;
  final VoidCallback onInfoTap;

  const LeaveBalanceDisplay({
    super.key,
    required this.leaveBalance,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
       // Use surface color for this container background
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Leave Balance',
             // Use TextTheme
            style: textTheme.titleMedium,
          ),
          GestureDetector(
            onTap: onInfoTap,
            child: Row(
              children: [
                Text(
                  '$leaveBalance Days',
                   // Use TextTheme, bold, primary accent color
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                 // Use primary accent color
                Icon(Icons.info_outline, size: 20, color: colorScheme.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}