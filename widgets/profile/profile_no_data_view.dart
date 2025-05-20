import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';

// Widget displayed when no profile data is found
class NoDataView extends StatelessWidget {
  final VoidCallback onRefresh; // Callback for the refresh button

  const NoDataView({required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      // Use Container for alignment and padding
      alignment: Alignment.center,
      padding: const EdgeInsets.all(kSectionPaddingHorizontal * 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon representing no data found
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withAlpha(204),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_search_rounded,
              size: 44,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: kItemSpacing * 1.2),
          // Main message
          Text(
            'Profile Not Found',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: kSmallItemSpacing),
          // Informative sub-message
          Text(
            'We couldn\'t find profile data.\nPlease try refreshing.', // Updated text
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: kSectionSpacing * 1.2), // Space before button
          // Refresh button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.refresh_rounded),
            onPressed: onRefresh, // Call the refresh callback
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
