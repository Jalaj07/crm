import 'package:flutter/material.dart';
import 'dart:math' as math; // Needed for Pi constant in Transform.rotate

// Adjust import paths as needed
import '../../models/sidebar_item_config.dart';
import 'sidebar_menu_tile.dart';

class SidebarCollapsibleSection extends StatelessWidget {
  final SidebarItemConfig sectionItem;
  final bool isExpanded;
  final VoidCallback onHeaderTap;
  final Function(int) onChildTap;
  final int selectedIndex; // To determine which child is selected

  const SidebarCollapsibleSection({
    super.key,
    required this.sectionItem,
    required this.isExpanded,
    required this.onHeaderTap,
    required this.onChildTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Default color for section header if none specified
    final Color defaultIconColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    // Determine the color for the section header and children, falling back to default greyish color
    final Color sectionColor = sectionItem.color ?? defaultIconColor;

    // Increased Padding to Shift Section Further Right
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ), // Base left padding for the section
      child: Column(
        children: [
          // Section Header (tappable to expand/collapse)
          _buildSectionHeader(
            context: context,
            title: sectionItem.title,
            icon: sectionItem.icon,
            color: sectionColor,
            isExpanded: isExpanded,
            onTap: onHeaderTap, // Use the callback passed from the parent
          ),
          // Animated container for smoothly showing/hiding children
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child:
                !isExpanded
                    ? const SizedBox.shrink() // Hide when collapsed
                    : Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        // Map each child item to a SidebarMenuTile widget
                        children:
                            sectionItem.children!
                                .map(
                                  (childItem) => SidebarMenuTile(
                                    item: childItem,
                                    // Pass the section's color down to children
                                    sectionColor: sectionColor,
                                    // Check if this specific child is the selected one
                                    isSelected:
                                        childItem.navigationIndex ==
                                        selectedIndex,
                                    // Children are always indented level 1 relative to section header
                                    indentLevel: 1,
                                    // Pass the child tap handler down
                                    onTap:
                                        () => onChildTap(
                                          childItem.navigationIndex!,
                                        ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // --- Build Section Header (kept private within this widget) ---
  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color headerTextColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color chevronColor =
        isDarkMode ? Colors.grey[500]! : Colors.grey[600]!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            children: [
              Icon(icon, color: color.withAlpha(204), size: 18),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: headerTextColor,
                    letterSpacing: 0.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Animated rotating chevron
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                tween: Tween<double>(begin: 0, end: isExpanded ? 0.5 : 0),
                builder: (context, rotation, child) {
                  return Transform.rotate(
                    angle: rotation * math.pi, // radians
                    child: child!,
                  );
                },
                child: Icon(Icons.expand_more, color: chevronColor, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
