import 'package:flutter/material.dart';
import 'home_upcoming_list_item.dart'; // Import the list item widget

// Define a simple data structure for upcoming items (can be a class/model later)
class UpcomingItemData {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  final int id; // Example: for identifying which item was tapped

  UpcomingItemData({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
    required this.id,
  });
}

// Constants
const EdgeInsets _cardPadding = EdgeInsets.all(14.0); // reduced from 20.0
const SizedBox _spacingW12 = SizedBox(width: 12);
const SizedBox _spacingH12 = SizedBox(height: 8);

class UpcomingEvents extends StatelessWidget {
  final List<UpcomingItemData> items;

  final Function(int id)?
  onItemTap; // Callback when an item is tapped, passing its ID

  const UpcomingEvents({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final titleIconColor = colorScheme.tertiaryContainer;
    final Color bgColor = colorScheme.surface;

    return Card(
      shape:
          theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: theme.cardTheme.elevation ?? 2,
      margin: theme.cardTheme.margin ?? EdgeInsets.zero,
      color: bgColor,
      child: Padding(
        padding: _cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: titleIconColor.withAlpha(33),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        color: titleIconColor,
                        size: 20,
                      ),
                    ),
                    _spacingW12,
                    Text(
                      'Upcoming',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: theme.dividerTheme.color ?? colorScheme.outline),
            _spacingH12,
            // List Items
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No upcoming events.',
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap:
                    true, // Important inside a Column/SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return UpcomingListItem(
                    title: item.title,
                    time: item.time,
                    icon: item.icon,
                    iconColor: item.color,
                    // onTap: onItemTap != null ? () => onItemTap!(item.id) : null, // Pass ID back
                  );
                },
                separatorBuilder:
                    (context, index) => const Divider(
                      height: 1,
                      thickness: 1,
                    ), // Use themed divider
              ),
          ],
        ),
      ),
    );
  }
}
