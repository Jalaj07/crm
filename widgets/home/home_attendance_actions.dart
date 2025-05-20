import 'package:flutter/material.dart';
import 'home_clock_in_button.dart';
import 'home_request_leave_button.dart';

// Constants
const EdgeInsets _cardPadding = EdgeInsets.all(14.0);
const SizedBox _spacingW12 = SizedBox(width: 12);
const SizedBox _spacingH20 = SizedBox(height: 16);
const SizedBox _spacingH12 = SizedBox(height: 8);

class AttendanceActions extends StatelessWidget {
  final VoidCallback onClockInPressed;
  final VoidCallback onClockOutPressed;
  final VoidCallback onRequestLeavePressed;
  final bool isLoading;
  final bool isClockedIn;
  final DateTime? lastClockIn;
  final DateTime? lastClockOut;

  const AttendanceActions({
    super.key,
    required this.onClockInPressed,
    required this.onClockOutPressed,
    required this.onRequestLeavePressed,
    this.isLoading = false,
    this.isClockedIn = false,
    this.lastClockIn,
    this.lastClockOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final Color bgColor = colorScheme.surface;

    return Card(
      shape:
          theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: theme.cardTheme.elevation ?? 1,
      margin: theme.cardTheme.margin ?? EdgeInsets.zero,
      color: bgColor,
      child: Padding(
        padding: _cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(33),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: colorScheme.primary,
                    size: theme.iconTheme.size ?? 20,
                  ),
                ),
                _spacingW12,
                Text(
                  'Attendance',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            _spacingH20,
            // Last Clock In/Out Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeDisplay(
                  context,
                  'Last Clock In',
                  lastClockIn,
                  Icons.login_rounded,
                  colorScheme.primary,
                ),
                _buildTimeDisplay(
                  context,
                  'Last Clock Out',
                  lastClockOut,
                  Icons.logout_rounded,
                  colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: theme.dividerTheme.color ?? colorScheme.outline),
            _spacingH12,
            // Clock In Button
            ClockInButton(
              onPressed: onClockInPressed,
              isLoading: isLoading && isActiveClockIn(),
              isClockIn: true,
              isActive: !isClockedIn,
              isSuccess: isClockedIn,
            ),
            _spacingH12,
            // Clock Out Button
            ClockInButton(
              onPressed: onClockOutPressed,
              isLoading: isLoading && isActiveClockOut(),
              isClockIn: false,
              isActive: isClockedIn,
              isSuccess: !isClockedIn && lastClockOut != null,
            ),
            _spacingH12,
            // Request Leave Button
            RequestLeaveButton(
              onPressed: onRequestLeavePressed,
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(
    BuildContext context,
    String label,
    DateTime? time,
    IconData icon,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size:
                  Theme.of(context).iconTheme.size != null
                      ? Theme.of(context).iconTheme.size! * 0.6
                      : 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          time != null
              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
              : '--:--',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  bool isActiveClockIn() => !isClockedIn;
  bool isActiveClockOut() => isClockedIn;
}
