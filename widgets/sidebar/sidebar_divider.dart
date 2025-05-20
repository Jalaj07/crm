import 'package:flutter/material.dart';

class SidebarDivider extends StatelessWidget {
  const SidebarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color dividerColor =
        isDarkMode ? Colors.white.withAlpha(25) : Colors.black.withAlpha(25);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Divider(height: 1, thickness: 1, color: dividerColor),
    );
  }
}
