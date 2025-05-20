import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';

// Widget for displaying section titles
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key}); // Const constructor

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      // Padding adjusted to align with StatCard margins visually
      padding: const EdgeInsets.only(
        left: kSectionPaddingHorizontal + 4, // Adjust left alignment slightly
        right: kSectionPaddingHorizontal,
        top:
            kItemSpacing *
            0.5, // Less space above title when preceded by another section
        bottom: kSmallItemSpacing * 1.5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Vertical accent bar
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: kSmallItemSpacing),
          // Title text (allows wrapping)
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
