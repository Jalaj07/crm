import 'package:flutter/material.dart';
// Adjust import path as needed
import '../../models/sidebar_item_config.dart';

class SidebarMenuTile extends StatelessWidget {
  final SidebarItemConfig item;
  final bool isSelected;
  final int indentLevel; // 0 for top-level/actions, 1 for children
  final VoidCallback? onTap; // Callback when tapped
  final Color?
  sectionColor; // Color inherited from parent section (if applicable)

  const SidebarMenuTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.indentLevel,
    this.onTap,
    this.sectionColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color defaultIconColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

    // Determine effective colors based on selection, item overrides, section context, and theme
    final Color baseColor =
        item.color ?? // Use item's specific color first
        sectionColor ?? // Then use section's color (for children)
        (item.isAction
            ? defaultIconColor
            : primaryColor); // Fallback based on type

    final Color effectiveIconColor = isSelected ? Colors.white : baseColor;
    final Color effectiveTextColor =
        isSelected
            ? primaryColor
            : (isDarkMode ? Colors.grey[300]! : Colors.grey[800]!);
    final Color tileBackgroundColor =
        isSelected ? primaryColor.withAlpha(31) : Colors.transparent;
    // Use a slightly different alpha for icon background based on dark mode for better contrast
    final Color iconBackgroundColor =
        isSelected ? baseColor : baseColor.withAlpha(isDarkMode ? 51 : 36);
    final List<BoxShadow>? iconBoxShadow =
        isSelected
            ? [
              BoxShadow(
                color: baseColor.withAlpha(89),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]
            : null;

    // Increased indentation multiplier
    final double leftPadding = 8.0 + (indentLevel * 20.0);

    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding, // Apply calculated left padding
        right: 8.0,
        bottom: 4.0,
      ),
      child: Material(
        color: tileBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap, // Use the provided onTap callback
          splashColor: primaryColor.withAlpha(25),
          highlightColor: primaryColor.withAlpha(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                // Icon background and Icon
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: iconBoxShadow,
                  ),
                  child: Icon(item.icon, color: effectiveIconColor, size: 16),
                ),
                const SizedBox(width: 12),
                // Title Text
                Expanded(
                  child: Text(
                    item.title, // Use title directly
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: effectiveTextColor,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Selection Indicator (Blue line on the right) - only for navigable items
                if (item.navigationIndex != null && item.navigationIndex! >= 0)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 4 : 0,
                    height: 28,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
