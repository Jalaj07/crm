import 'package:flutter/material.dart';
import '../../../constants/travelmanagement_filter_status.dart'; // Adjust path
import 'travelmanagement_stat_card.dart';
import '../../../theme/central_app_theme_color.dart'; // Adjust path

class StatsOverviewRow extends StatelessWidget {
  final int totalCount;
  final int pendingCount;
  final int approvedCount;
  // Could add other counts here (inProgress, completed etc.)

  const StatsOverviewRow({
    super.key,
    required this.totalCount,
    required this.pendingCount,
    required this.approvedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusTheme = theme.extension<StatusColors>();

    if (statusTheme == null) {
      return const Center(child: Text("Theme error: StatusColors not found"));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          StatCard(
            title: 'Total',
            value: totalCount.toString(),
            icon: Icons.all_inbox_outlined, // Changed Icon
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          StatCard(
            title: FilterStatus.pending,
            value: pendingCount.toString(),
            icon: Icons.pending_actions_outlined, // Changed Icon
            color: FilterStatus.getColor(FilterStatus.pending, statusTheme),
            // Use central color logic
          ),
          const SizedBox(width: 12),
          StatCard(
            title: FilterStatus.approved,
            value: approvedCount.toString(),
            icon: Icons.check_circle_outline, // Changed Icon
            color: FilterStatus.getColor(
              FilterStatus.approved,
              statusTheme,
            ), // Use central color logic
          ),
          // Could add more StatCards here for other statuses
        ],
      ),
    );
  }
}
