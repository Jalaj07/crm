// widgets/custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';

// Assume kMoreButtonId is defined and accessible or passed
// For standalone example:
// const String kMoreButtonId = "__MORE_BUTTON__";


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; // This is the LOCAL index of the selected item in pageIndices that should be highlighted.
                          // It will be -1 if no specific page item is active (e.g., "More" was tapped).
  final Function(int) onTap; // Callback when an item is tapped, receives its LOCAL index from `pageIndices`.
  final List<dynamic> pageIndices; // List of items: global page indices (int) OR special IDs (String for "More").
  final IconData Function(dynamic itemIdentifier) getIconForIndex;
  final String Function(dynamic itemIdentifier) getLabelForIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex, // This refers to index in `pageIndices`
    required this.onTap,
    required this.pageIndices, // Example: [0, 1, 2, "__MORE_BUTTON__"]
    required this.getIconForIndex,
    required this.getLabelForIndex,
  });

  @override
  Widget build(BuildContext context) {
    // ... (your existing styling for the bar itself) ...
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final unselectedColor = colorScheme.onSurface.withAlpha(153);

    if (pageIndices.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 60, // Consistent height
      decoration: BoxDecoration( /* ... */ ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(pageIndices.length, (localIndex) {
          final itemIdentifier = pageIndices[localIndex]; // e.g., 0 or "__MORE_BUTTON__"

          // isSelected is true if the `currentIndex` passed to this widget matches the `localIndex`
          // of the item being built.
          final bool isSelected = (localIndex == currentIndex);

          return _buildNavItem(
            icon: getIconForIndex(itemIdentifier),
            label: getLabelForIndex(itemIdentifier),
            isSelected: isSelected,
            selectedColor: primaryColor,
            unselectedColor: unselectedColor,
            onTap: () => onTap(localIndex), // VERY IMPORTANT: Pass back the localIndex
          );
        }),
      ),
    );
  }

  // _buildNavItem remains mostly the same, ensure it correctly uses isSelected.
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    required VoidCallback onTap,
  }) {
    final itemColor = isSelected ? selectedColor : unselectedColor;
    final bgColor = isSelected ? selectedColor.withAlpha(25) : Colors.transparent;
    final textStyle = TextStyle(
        color: itemColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 11,
    );

    return Expanded( /* ... your existing nav item UI ... */
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: itemColor, size: 24),
              const SizedBox(height: 3),
              Text(label, style: textStyle, overflow: TextOverflow.ellipsis, maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }
}