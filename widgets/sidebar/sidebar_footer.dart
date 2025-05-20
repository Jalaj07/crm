import 'package:flutter/material.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color mutedTextColor =
        isDarkMode ? Colors.grey[500]! : Colors.grey[600]!;
    final Color versionTextColor =
        isDarkMode ? Colors.grey[600]! : Colors.grey[500]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 12, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 14, color: mutedTextColor),
              const SizedBox(width: 6),
              Text(
                '© 2025 GainHub',
                style: TextStyle(color: mutedTextColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'v2.5.1',
            style: TextStyle(color: versionTextColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
