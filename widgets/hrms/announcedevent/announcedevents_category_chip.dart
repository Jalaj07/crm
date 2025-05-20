import 'package:flutter/material.dart';
import 'package:flutter_development/models/hrms/announced%20events/announcedevents_event_category.dart'; // Adjust path

class CategoryChip extends StatelessWidget {
  final EventCategory category;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isSelected = category.isSelected;

    // Determine background color
    final Color chipColor =
        isSelected ? category.color : colorScheme.surfaceContainerHighest;

    // --- CORRECTED Content Color Logic ---
    final Color contentColor;
    if (isSelected) {
      // *** FIX: Always use white (or a light color) for icon/text when selected ***
      // This ensures contrast against most category colors (like blueGrey).
      contentColor = colorScheme.onSurfaceVariant;
    } else {
      // Use the theme's standard color for content on the unselected background
      contentColor = colorScheme.onSurfaceVariant;
    }
    final Color contentColor1;
    if (isSelected) {
      // *** FIX: Always use white (or a light color) for icon/text when selected ***
      // This ensures contrast against most category colors (like blueGrey).
      contentColor1 = colorScheme.surface;
    } else {
      // Use the theme's standard color for content on the unselected background
      contentColor1 = colorScheme.onSurfaceVariant;
    }
    // --- End Correction ---

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: chipColor,
              shape: BoxShape.circle,
              // No shadow needed based on previous feedback
            ),
            child: Icon(category.icon, color: contentColor1, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            // Use theme text style + calculated content color
            style: textTheme.bodySmall?.copyWith(
              color: contentColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
