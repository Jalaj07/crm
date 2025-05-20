import 'package:flutter/material.dart';

// Constants specific to UpcomingListItem
const SizedBox _spacingW16 = SizedBox(width: 16);
const SizedBox _spacingW8 = SizedBox(width: 8);

class UpcomingListItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap; // Optional callback for tapping the item

  const UpcomingListItem({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconBackgroundColor = iconColor.withAlpha(25); // lighter background

    return InkWell(
      // Make the row tappable if onTap is provided
      onTap: onTap,
      borderRadius: BorderRadius.circular(8), // Match visual rounding
      child: Padding(
        // Add vertical padding for spacing between items and touch area
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 2.0,
        ), // reduced from 12.0, 4.0
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7), // reduced from 10
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: iconColor), // reduced from 20
            ),
            _spacingW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: textTheme.bodySmall?.copyWith(
                      color: textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null) ...[
              // Only show chevron if tappable
              _spacingW8,
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.black,
                size: 18,
              ), // reduced size
            ] else ...[
              _spacingW8, // Maintain spacing even if chevron isn't shown
            ],
          ],
        ),
      ),
    );
  }
}
