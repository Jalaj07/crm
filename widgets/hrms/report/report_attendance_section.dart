// lib/screens/employee_reports/widgets/attendance_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/widgets/hrms/report/report_attendance_stats.dart';
import 'package:table_calendar/table_calendar.dart';

import 'report_shared/report_expandable_dashboard_card.dart'; // Adjust import
import 'report_attendance_calendar.dart'; // Adjust import

class AttendanceSection extends StatelessWidget {
  // State properties passed down
  final bool isExpanded;
  final Map<DateTime, String> attendanceData;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;

  // Callbacks passed down
  final VoidCallback onExpansionTap;
  final GetDateStatusCallback getDateStatus;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;

  const AttendanceSection({
    super.key,
    required this.isExpanded,
    required this.attendanceData,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onExpansionTap,
    required this.getDateStatus,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableDashboardCard(
      title: 'Attendance',
      isExpanded: isExpanded,
      onTap: onExpansionTap, // Use the passed callback
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AttendanceStats(
            // Pass needed data to Stats widget
            attendanceData: attendanceData,
            focusedDay: focusedDay,
          ),
          const SizedBox(height: 20),
          const Text(
            'Calendar View',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          AttendanceCalendar(
            // Pass data and callbacks to Calendar widget
            attendanceData: attendanceData,
            focusedDay: focusedDay,
            selectedDay: selectedDay,
            calendarFormat: calendarFormat,
            getDateStatus: getDateStatus, // Pass the function
            onDaySelected: onDaySelected, // Pass the callback
            onFormatChanged: onFormatChanged, // Pass the callback
            onPageChanged: onPageChanged, // Pass the callback
          ),
        ],
      ),
    );
  }
}
