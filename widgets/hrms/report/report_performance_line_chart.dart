// lib/screens/employee_reports/widgets/performance_line_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../models/hrms/report_performance_data.dart'; // Adjust import path

class PerformanceLineChart extends StatelessWidget {
  final List<PerformanceData> performanceData;

  const PerformanceLineChart({super.key, required this.performanceData});

  @override
  Widget build(BuildContext context) {
    if (performanceData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No performance data available.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Colors are kept exactly the same
    final Color gridLineColor = const Color(0xffe7e8ec);
    final Color bottomTitleColor = const Color(0xff68737d);
    final Color leftTitleColor = const Color(0xff67727d);
    final Color chartBorderColor = const Color(0xffe7e8ec);
    final Color lineBarColor = Colors.blueAccent;
    final Color dotColor = Colors.blueAccent;
    final Color dotStrokeColor = Colors.white;
    final Color belowBarGradientStart = Colors.blueAccent.withAlpha(76);
    final Color belowBarGradientEnd = Colors.blueAccent.withAlpha(0);
    final Color tooltipBgColor = Colors.blueAccent.withAlpha(204);
    final Color tooltipTextColor = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Trend',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Monthly scores',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.8,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 10,
                getDrawingHorizontalLine:
                    (value) => FlLine(color: gridLineColor, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      final String text =
                          (index >= 0 && index < performanceData.length)
                              ? DateFormat(
                                'MMM',
                              ).format(performanceData[index].date)
                              : '';
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: bottomTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 10,
                    reservedSize: 35,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: leftTitleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: chartBorderColor, width: 1),
              ),
              minX: 0,
              maxX:
                  performanceData.isNotEmpty
                      ? performanceData.length.toDouble() - 1
                      : 0, // Handle empty list case for maxX
              minY: 60,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    performanceData.length,
                    (index) =>
                        FlSpot(index.toDouble(), performanceData[index].score),
                  ),
                  isCurved: true,
                  color: lineBarColor,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter:
                        (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 4,
                          color: dotColor,
                          strokeWidth: 1.5,
                          strokeColor: dotStrokeColor,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [belowBarGradientStart, belowBarGradientEnd],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => tooltipBgColor,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots
                        .map((barSpot) {
                          final flSpot = barSpot;
                          final index = flSpot.x.toInt();
                          if (index < 0 || index >= performanceData.length) {
                            return null;
                          }

                          final data = performanceData[index];
                          final month = DateFormat(
                            'MMMM yyyy',
                          ).format(data.date);

                          return LineTooltipItem(
                            '$month\n',
                            TextStyle(
                              color: tooltipTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: data.score.toStringAsFixed(0),
                                style: TextStyle(
                                  color: tooltipTextColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: ' pts',
                                style: TextStyle(
                                  color: tooltipTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            textAlign: TextAlign.left,
                          );
                        })
                        .whereType<LineTooltipItem>()
                        .toList();
                  },
                ),
                handleBuiltInTouches: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
