// lib/screens/employee_reports/widgets/kpi_grid.dart
import 'package:flutter/material.dart';

import 'report_shared/report_kpi_card_item.dart'; // Adjust import path

class KpiGrid extends StatelessWidget {
  final Map<String, double> kpiData;

  const KpiGrid({super.key, required this.kpiData});

  @override
  Widget build(BuildContext context) {
    if (kpiData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No KPI data available.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Performance Indicators',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kpiData.length,
          itemBuilder: (context, index) {
            final entry = kpiData.entries.elementAt(index);
            IconData icon;
            Color color; // Base color

            // Determine icon and base color (Logic unchanged)
            switch (entry.key.toLowerCase()) {
              case 'tasks completed':
                icon = Icons.task_alt;
                color = Colors.green;
                break;
              case 'projects delivered':
                icon = Icons.rocket_launch_outlined;
                color = Colors.blue;
                break;
              case 'client satisfaction':
                icon = Icons.sentiment_satisfied_alt;
                color = Colors.orange;
                break;
              case 'team collaboration':
                icon = Icons.groups_outlined;
                color = Colors.purple;
                break;
              default:
                icon = Icons.query_stats;
                color = Colors.grey;
            }
            // Use the KpiCardItem widget
            return KpiCardItem(
              title: entry.key,
              value: entry.value,
              icon: icon,
              color: color, // Pass the base color
            );
          },
        ),
      ],
    );
  }
}
