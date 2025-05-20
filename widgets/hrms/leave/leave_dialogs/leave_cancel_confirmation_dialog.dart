import 'package:flutter/material.dart';

Future<bool?> showCancelLeaveConfirmationDialog(BuildContext context) async {
  // AlertDialog uses DialogThemeData for shape, background, title/content styles
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      final colorScheme = Theme.of(dialogContext).colorScheme; // Use dialog context theme
      return AlertDialog(
        // Shape, BackgroundColor, TitleTextStyle, ContentTextStyle from theme
        title: const Text('Cancel Leave Request'),
        content: const Text(
          'Are you sure you want to cancel this leave request? This action cannot be undone.',
        ),
        actions: <Widget>[
           // TextButton uses TextButtonThemeData for default style
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
           // Specific override for error color on Yes button
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error, // Use error color
            ),
            child: const Text('Yes, Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      );
    },
  );
}