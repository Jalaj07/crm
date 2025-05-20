// lib/screens/employee_reports/widgets/summary_cards_grid.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/hrms/report_performance_data.dart'; // Adjust import path
import 'report_shared/report_summary_card_item.dart'; // Adjust import path

class SummaryCardsGrid extends StatelessWidget {
  final List<PerformanceData> performanceData;
  final Map<String, int> leaveData;
  final Map<String, int> leaveUsed;

  const SummaryCardsGrid({
    super.key,
    required this.performanceData,
    required this.leaveData,
    required this.leaveUsed,
  });

  @override
  Widget build(BuildContext context) {
    int annualLeaveBalance =
        (leaveData['Annual Leave'] ?? 0) - (leaveUsed['Annual Leave'] ?? 0);
    DateTime now = DateTime.now();
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
    String nextPayDate = DateFormat('MMM d').format(endOfMonth);
    // Sample amount - consider passing if dynamic

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 11,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        SummaryCardItem(
          title: 'Attendance Rate',
          value: '92%', // Sample data - consider passing if dynamic
          icon: Icons.check_circle_outline,
          color: Colors.green, // Pass base color
          subtitle: 'This Month',
        ),
        SummaryCardItem(
          title: 'Performance',
          value:
              performanceData.isNotEmpty
                  ? performanceData.last.score.toInt().toString()
                  : 'N/A',
          icon: Icons.trending_up,
          color: Colors.blue, // Pass base color
          subtitle: 'Current',
        ),
        SummaryCardItem(
          title: 'Annual Leave',
          value: '$annualLeaveBalance days',
          icon: Icons.beach_access,
          color: Colors.amber, // Pass base color
          subtitle: 'Remaining',
        ),
        SummaryCardItem(
          title: 'Next Payday',
          value: nextPayDate,
          icon: Icons.account_balance_wallet_outlined,
          color: Colors.purple, // Pass base color
          subtitle: '2025',
        ),
      ],
    );
  }
}
