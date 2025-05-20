// lib/screens/employee_reports/widgets/shared/summary_card_item.dart
import 'package:flutter/material.dart';

class SummaryCardItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color; // Expecting Colors.green, Colors.blue, etc.
  final String subtitle;

  const SummaryCardItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color, // Base color passed in
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color for the value text
    Color valueColor = color; // Default to the base color

    // *** NO [] OPERATOR USED ***
    // Explicitly check for the specific MaterialColors used and assign shades
    // Add more else-if checks if other MaterialColors need specific shades
    if (color == Colors.green) {
      valueColor = Colors.green.shade700; // Direct access to shade
    } else if (color == Colors.blue) {
      valueColor = Colors.blue.shade700; // Direct access to shade
    } else if (color == Colors.amber) {
      valueColor = Colors.amber.shade700; // Direct access to shade
    } else if (color == Colors.purple) {
      valueColor = Colors.purple.shade700; // Direct access to shade
    }
    // If the input 'color' is not one of the above, valueColor remains the original 'color'

    // Title color remains hardcoded grey
    Color titleColor = Colors.grey[700] ?? Colors.grey;
    // Subtitle color remains hardcoded grey
    Color subtitleColor = Colors.grey[600] ?? Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            // Value Text
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: subtitleColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
