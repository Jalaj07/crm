// lib/screens/employee_reports/widgets/shared/kpi_card_item.dart
import 'package:flutter/material.dart';

class KpiCardItem extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color color; // Expecting Colors.green, Colors.blue, etc.

  const KpiCardItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color, // Base color passed in
  });

  @override
  Widget build(BuildContext context) {
    final bool isPercentage =
        title.toLowerCase().contains('satisfaction') ||
        title.toLowerCase().contains('collaboration');
    final String displayValue =
        isPercentage ? '${value.toInt()}%' : value.toInt().toString();

    // Determine the specific colors for icon and value text
    Color iconColor = color; // Default to base color
    Color valueColor = color; // Default to base color

    // *** NO [] OPERATOR USED ***
    // Explicitly check for the specific MaterialColors used in KpiGrid
    if (color == Colors.green) {
      iconColor = Colors.green.shade700; // Direct shade access
      valueColor = Colors.green.shade800; // Direct shade access
    } else if (color == Colors.blue) {
      iconColor = Colors.blue.shade700;
      valueColor = Colors.blue.shade800;
    } else if (color == Colors.orange) {
      iconColor = Colors.orange.shade700;
      valueColor = Colors.orange.shade800;
    } else if (color == Colors.purple) {
      iconColor = Colors.purple.shade700;
      valueColor = Colors.purple.shade800;
    } else if (color == Colors.grey) {
      // Handle the default case from KpiGrid
      iconColor = Colors.grey.shade700;
      valueColor = Colors.grey.shade800;
    }
    // If the input 'color' is not one of the above, iconColor and valueColor
    // remain the original 'color'.

    // Title color remains hardcoded grey
    Color titleColor = Colors.grey[800] ?? Colors.grey;
    // Background color uses the base color with alpha (this is safe)
    Color cardBackgroundColor = color.withAlpha(25);

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: cardBackgroundColor, // Use determined background color
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 1.0,
        ), // Original padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                // Use the explicitly determined iconColor (base or specific shade)
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 8,
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1), // Original spacing
            Text(
              displayValue,
              // Use the explicitly determined valueColor (base or specific shade)
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
