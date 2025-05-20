import 'package:flutter/material.dart';
import 'home_stat_card.dart'; // Import the StatCard widget

// Constants
const SizedBox _spacingW16 = SizedBox(width: 16);

class StatsOverview extends StatelessWidget {
  // Pass data needed for the stat cards
  final String hoursValue;
  final String leaveValue;

  const StatsOverview({
    super.key,
    required this.hoursValue,
    required this.leaveValue,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Hours Today',
            value: hoursValue,
            icon: Icons.timer_outlined,
            color: colorScheme.primary,
          ),
        ),
        _spacingW16,
        Expanded(
          child: StatCard(
            title: 'Leave Balance',
            value: leaveValue,
            icon: Icons.event_available_outlined,
            color: colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
