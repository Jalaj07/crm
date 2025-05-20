// lib/screens/employee_reports/widgets/attendance_stats.dart
import 'package:flutter/material.dart';

class AttendanceStats extends StatelessWidget {
  final Map<DateTime, String> attendanceData;
  final DateTime
  focusedDay; // To calculate stats for the currently viewed month

  const AttendanceStats({
    super.key,
    required this.attendanceData,
    required this.focusedDay,
  });

  // Helper widget for individual stat items
  Widget _buildAttendanceStatItem(String label, int count, Color color) {
    Color valueColor = color;
    // Apply darker shade for value if base color supports it
    if (color is MaterialColor) {
      valueColor = color[700] ?? color;
    } else if (color is MaterialAccentColor) {
      valueColor = color[700] ?? color;
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // Take minimum space
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ), // Consistent label color
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int present = 0, absent = 0, late = 0, holiday = 0;
    bool dataExistsForMonth = false;

    attendanceData.forEach((date, status) {
      if (date.year == focusedDay.year && date.month == focusedDay.month) {
        dataExistsForMonth = true; // Mark that we found data
        if (status == 'present') present++;
        if (status == 'absent') absent++;
        if (status == 'late') late++;
        if (status == 'holiday') holiday++;
      }
    });

    // Display message if no data for the focused month
    if (!dataExistsForMonth) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No attendance data for this month.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    // Display stats if data exists
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAttendanceStatItem('Present', present, Colors.green),
        _buildAttendanceStatItem('Absent', absent, Colors.red),
        _buildAttendanceStatItem('Late', late, Colors.orange),
        _buildAttendanceStatItem('Holiday', holiday, Colors.blueAccent),
      ],
    );
  }
}
