import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String categoryName;

  const EmptyStateWidget({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Use theme colors directly, rely on text theme definitions for emphasis
    final iconColor = colorScheme.onSurface.withAlpha(102); // Mid-low emphasis for icon
    // Title uses standard text theme color (titleLarge)
    // Subtitle uses standard text theme color (bodyMedium) but with lower emphasis opacity
    final subtitleColor = colorScheme.onSurface.withAlpha(153);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_outlined, size: 80, color: iconColor),
          const SizedBox(height: 16),
          Text(
            'No $categoryName announcements',
            style: textTheme.titleLarge, // Color inherited
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for updates or select another category.',
            style: textTheme.bodyMedium?.copyWith(color: subtitleColor), // Apply muted color
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}