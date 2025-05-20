// lib/screens/employee_reports/widgets/attendance_calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Define a type alias for the status getter function for clarity
typedef GetDateStatusCallback = String? Function(DateTime date);

class AttendanceCalendar extends StatelessWidget {
  final Map<DateTime, String> attendanceData; // Needed for marking days
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final GetDateStatusCallback
  getDateStatus; // Function to get status for coloring
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;

  const AttendanceCalendar({
    super.key,
    required this.attendanceData, // Keep original data map if needed by markers
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.getDateStatus,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  // Helper to build the simple purple dot marker (can be kept local)
  Widget _buildEventsMarker() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple[700],
      ),
      width: 7.0,
      height: 7.0,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2025, 1, 1), // Consider making these configurable
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: calendarFormat,
      // Pass callbacks directly to the TableCalendar
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,
      onPageChanged: onPageChanged,

      // Styling (remains the same, colors unchanged)
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        formatButtonTextStyle: const TextStyle(color: Colors.white),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20.0),
        ),
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.blue),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.blue),
      ),
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        weekendTextStyle: const TextStyle(color: Colors.redAccent),
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.blue.shade200,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange.shade300,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.purple.shade400,
          shape: BoxShape.circle,
        ),
      ),
      // Use the passed-in function for builders
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, focusedDate) {
          // Use focusedDate if needed here
          final String? status = getDateStatus(date);
          if (status != null && status != 'weekend') {
            Color backgroundColor;
            // Determine background color based on status (Colors are preserved)
            switch (status) {
              case 'present':
                backgroundColor = Colors.green.shade100;
                break;
              case 'absent':
                backgroundColor = Colors.red.shade100;
                break;
              case 'late':
                backgroundColor = Colors.orange.shade100;
                break;
              case 'holiday':
                backgroundColor = Colors.blue.shade100;
                break;
              default:
                backgroundColor = Colors.transparent;
            }
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                // Use isSameDay(date, DateTime.now()) for consistent today highlighting
                border:
                    isSameDay(date, DateTime.now())
                        ? Border.all(color: Colors.blueAccent, width: 1)
                        : null,
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }
          return null; // Allow default builder for weekends/empty days
        },
        markerBuilder: (context, date, events) {
          // Example marker logic (remains same) - depends on eventLoader result
          // Or use event list if populated
          // Add condition if you only want markers for specific statuses, e.g., holidays
          // if (status == 'holiday' && events.isNotEmpty) { // Adjust logic as needed
          // For demo, assume events means add a marker - refine if eventLoader is used
          if (attendanceData.containsKey(
                DateTime.utc(date.year, date.month, date.day),
              ) &&
              getDateStatus(date) == 'holiday') {
            // Example: Mark holidays
            return Positioned(right: 1, bottom: 1, child: _buildEventsMarker());
          }

          return null;
        },
        selectedBuilder: (context, date, focusedDate) {
          // Use focusedDate if needed
          final status = getDateStatus(date);
          Color circleColor =
              Colors.deepOrange.shade300; // Default selection color
          if (status != null && status != 'weekend') {
            // Determine selected color based on status (Colors are preserved)
            switch (status) {
              case 'present':
                circleColor = Colors.green.shade300;
                break;
              case 'absent':
                circleColor = Colors.red.shade300;
                break;
              case 'late':
                circleColor = Colors.orange.shade300;
                break;
              case 'holiday':
                circleColor = Colors.blue.shade300;
                break;
              default:
                break; // Use default if no specific status match
            }
          }
          // Use FadeTransition for standard selected look (Colors are preserved)
          return FadeTransition(
            opacity: const AlwaysStoppedAnimation(1.0),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          );
        },
        todayBuilder: (context, date, focusedDate) {
          // Use focusedDate if needed
          final status = getDateStatus(date);
          Color circleColor = Colors.blue.shade200; // Default today color
          if (status != null && status != 'weekend') {
            // Determine today color based on status (Colors are preserved)
            switch (status) {
              case 'present':
                circleColor = Colors.green.shade200;
                break;
              case 'absent':
                circleColor = Colors.red.shade200;
                break;
              case 'late':
                circleColor = Colors.orange.shade200;
                break;
              case 'holiday':
                circleColor = Colors.cyan.shade100;
                break;
              default:
                break; // Use default if no specific status match
            }
          }
          // Today's marker style (Colors are preserved)
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 1.5),
            ),
            child: Text(
              '${date.day}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          );
        },
      ),
      // eventLoader can be simplified if not actively loading external events
      eventLoader: (day) {
        // Example: return a list containing the status if you want markers based on status
        // final status = getDateStatus(day);
        // if (status != null && status != 'weekend' && status != 'present') { // Example: Add event for non-present days
        //   return [status];
        // }
        return []; // Return empty list if markers are handled purely in builder
      },
    );
  }
}
