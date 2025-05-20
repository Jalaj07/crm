// lib/screens/employee_reports/employee_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/widgets/hrms/report/report_attendance_section.dart';
import 'package:flutter_development/widgets/hrms/report/report_payroll_summary_section.dart';
import 'package:flutter_development/widgets/hrms/report/report_performance_section.dart';
import 'package:flutter_development/widgets/hrms/report/report_summary_cards_grid.dart';
import 'package:table_calendar/table_calendar.dart'; // Keep for CalendarFormat

// Import Models and Widgets (Adjust paths as needed)
import '../../models/hrms/report_performance_data.dart';

class EmployeeReportsScreen extends StatefulWidget {
  const EmployeeReportsScreen({super.key});

  @override
  EmployeeReportsScreenState createState() => EmployeeReportsScreenState();
}

class EmployeeReportsScreenState extends State<EmployeeReportsScreen> {
  // --- State Variables (Keep these here) ---
  bool _isAttendanceExpanded = false;
  bool _isPerformanceExpanded = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // --- Sample Data (Keep this here as the source of truth) ---
  final Map<DateTime, String> _attendanceData = {
    DateTime(2025, 4, 1): 'present', DateTime(2025, 4, 2): 'present',
    DateTime(2025, 4, 3): 'late', DateTime(2025, 4, 4): 'present',
    DateTime(2025, 4, 5): 'weekend', DateTime(2025, 4, 6): 'weekend',
    DateTime(2025, 4, 7): 'present', DateTime(2025, 4, 8): 'present',
    DateTime(2025, 4, 9): 'present', DateTime(2025, 4, 10): 'absent',
    DateTime(2025, 4, 11): 'present', DateTime(2025, 4, 12): 'weekend',
    DateTime(2025, 4, 13): 'weekend', DateTime(2025, 4, 14): 'present',
    DateTime(2025, 4, 15): 'holiday', DateTime(2025, 4, 16): 'present',
    DateTime(2025, 4, 17): 'present', DateTime(2025, 4, 18): 'present',
    DateTime(2025, 4, 19): 'weekend', DateTime(2025, 4, 20): 'weekend',
    DateTime(2025, 4, 21): 'late', DateTime(2025, 4, 22): 'present',
    DateTime(2025, 4, 23): 'present', DateTime(2025, 4, 24): 'present',
    DateTime(2025, 4, 25): 'present', DateTime(2025, 4, 26): 'weekend',
    DateTime(2025, 4, 27): 'weekend',
    DateTime(2025, 5, 1): 'holiday', // Add data for another month if needed
    DateTime(2025, 5, 2): 'present',
  };

  final List<PerformanceData> _performanceData = [
    PerformanceData(DateTime(2025, 1), 78),
    PerformanceData(DateTime(2025, 2), 82),
    PerformanceData(DateTime(2025, 3), 79),
    PerformanceData(DateTime(2025, 4), 85),
  ];

  final Map<String, double> _kpiData = {
    'Tasks Completed': 42,
    'Projects Delivered': 3,
    'Client Satisfaction': 92,
    'Team Collaboration': 88,
  };

  final Map<String, int> _leaveData = {
    'Annual Leave': 15,
    'Sick Leave': 10,
    'Personal Leave': 5,
    'Unpaid Leave': 10,
  };

  final Map<String, int> _leaveUsed = {
    'Annual Leave': 5,
    'Sick Leave': 2,
    'Personal Leave': 1,
    'Unpaid Leave': 0,
  };

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Consider adding an AppBar if needed
      // appBar: AppBar(title: Text("Employee Reports")),
      body: _buildDashboardBody(),
    );
  }

  // --- Main Body Builder (Uses new Widgets) ---
  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use the SummaryCardsGrid widget
          SummaryCardsGrid(
            performanceData: _performanceData,
            leaveData: _leaveData,
            leaveUsed: _leaveUsed,
          ),
          const SizedBox(height: 24),

          // Use the PayrollSummarySection widget
          const PayrollSummarySection(),
          const SizedBox(height: 16),

          // Use the AttendanceSection widget
          AttendanceSection(
            isExpanded: _isAttendanceExpanded,
            attendanceData: _attendanceData,
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            getDateStatus: _getDateStatus, // Pass the method reference
            onExpansionTap: () {
              // Callback to toggle state
              setState(() {
                _isAttendanceExpanded = !_isAttendanceExpanded;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              // Callback
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              // Callback
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // Callback
              setState(() {
                // Reset selected day when page changes? Optional.
                // _selectedDay = null;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 16),

          // Use the PerformanceSection widget
          PerformanceSection(
            isExpanded: _isPerformanceExpanded,
            performanceData: _performanceData,
            kpiData: _kpiData,
            onExpansionTap: () {
              // Callback to toggle state
              setState(() {
                _isPerformanceExpanded = !_isPerformanceExpanded;
              });
            },
          ),
          const SizedBox(height: 16), // Add some padding at the end
        ],
      ),
    );
  }

  // --- Helper Methods (Keep methods needed by child widgets) ---

  // Keep _getDateStatus here as it needs access to _attendanceData
  String? _getDateStatus(DateTime date) {
    // Compare UTC dates to avoid timezone issues if data keys are not timezone aware
    final DateTime compareDate = DateTime.utc(date.year, date.month, date.day);
    for (final entry in _attendanceData.entries) {
      // Ensure entry.key is also treated as UTC for comparison
      final DateTime entryDate = DateTime.utc(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );
      if (entryDate == compareDate) {
        return entry.value;
      }
    }
    // Check for weekend only if no specific status found
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return 'weekend';
    }
    return null; // No status and not a weekend
  }
}
