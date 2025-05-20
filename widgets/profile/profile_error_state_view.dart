import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';

// Widget displayed when profile loading fails
class ErrorStateView extends StatelessWidget {
  final Object? error; // The error object, can be null
  final VoidCallback onRetry; // Callback function for the retry button

  const ErrorStateView({this.error, required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      // Use a Container for alignment and padding
      alignment: Alignment.center,
      padding: const EdgeInsets.all(kSectionPaddingHorizontal * 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon representing error
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withAlpha(204),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              color: colorScheme.onErrorContainer,
              size: 44,
            ),
          ),
          const SizedBox(height: kItemSpacing * 1.2),
          // Main error message
          Text(
            'Failed to Load Profile',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: kSmallItemSpacing),
          // User guidance message
          Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          // Display error details only in debug mode and if error is present
          if (kDebugMode && error != null && error.toString().isNotEmpty) ...[
            const SizedBox(height: kItemSpacing),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.error.withAlpha(13),
                borderRadius: BorderRadius.circular(kSmallBorderRadius),
              ),
              child: Text(
                'Details: $error',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error.withAlpha(210),
                ),
              ),
            ),
          ],
          const SizedBox(height: kSectionSpacing * 1.2), // Space before button
          // Retry button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              // Optional: Style specifically for error state
              // backgroundColor: colorScheme.error,
              // foregroundColor: colorScheme.onError,
            ),
            icon: const Icon(Icons.refresh_rounded),
            onPressed: onRetry, // Call the retry callback
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
