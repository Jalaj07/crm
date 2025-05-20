// lib/screens/employee_reports/widgets/performance_section.dart
import 'package:flutter/material.dart';

import '../../../models/hrms/report_performance_data.dart'; // Adjust import path
import 'report_shared/report_expandable_dashboard_card.dart'; // Adjust import path
import 'report_performance_line_chart.dart'; // Adjust import path
import 'report_kpi_grid.dart'; // Adjust import path

class PerformanceSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onExpansionTap;
  final List<PerformanceData> performanceData;
  final Map<String, double> kpiData;

  const PerformanceSection({
    super.key,
    required this.isExpanded,
    required this.onExpansionTap,
    required this.performanceData,
    required this.kpiData,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableDashboardCard(
      title: 'Performance',
      isExpanded: isExpanded,
      onTap: onExpansionTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PerformanceLineChart(performanceData: performanceData), // Pass data
          const SizedBox(height: 24),
          KpiGrid(kpiData: kpiData), // Pass data
        ],
      ),
    );
  }
}
