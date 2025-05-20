// constants/modal_constants.dart
import 'package:flutter/material.dart';

class ModalConstants {
  // ... (most constants remain the same) ...
  static const double modalBorderRadius = 12.0;
  static const double modalElevation = 4.0;
  static const EdgeInsets modalPadding = EdgeInsets.all(
    16.0,
  ); // General Padding for the Modal Edges
  static const EdgeInsets headerPadding = EdgeInsets.fromLTRB(
    16.0,
    12.0,
    8.0,
    12.0,
  );
  // Content padding for lists/viewers - Slightly reduced vertical for tighter look
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );
  static const double modalSpacing = 8.0;

  static const double itemBorderRadius = 8.0;
  static const double itemElevation = 1.0;
  static const EdgeInsets itemPadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 10.0,
  );
  static const EdgeInsets itemMargin = EdgeInsets.only(
    bottom: 10.0,
  ); // Slightly reduce margin
  static const double iconBackgroundSize = 40.0;
  static const double iconSize = 20.0;
  static const double iconPadding = 8.0;
  static const double iconBorderRadius = 6.0;

  static const double buttonBorderRadius = 8.0;
  static const double buttonIconSize = 18.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 12.0,
  );

  // --- Helper Widgets ---

  static Widget buildModalHeader(
    BuildContext context,
    String title, {
    VoidCallback? onClose,
  }) {
    // ... (buildModalHeader remains the same) ...
    final theme = Theme.of(context);
    return Padding(
      padding: headerPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Allow title to wrap if needed
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 1,
            ),
          ),
          const SizedBox(width: modalSpacing), // Spacing before close button
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
            onPressed: onClose ?? () => Navigator.pop(context),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  static Widget buildModalContainer(
    BuildContext context,
    List<Widget> children,
  ) {
    // This container structure remains the same, maxHeight acts as the upper limit.
    // The dynamic height comes from how children inside size themselves.
    return Container(
      // Max constraints prevent extreme sizes, but doesn't force expansion
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height *
            0.75, // Slightly reduced max height if needed
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      // The Column's mainAxisSize: MainAxisSize.min allows it to shrink vertically
      child: Column(
        mainAxisSize: MainAxisSize.min, // <-- Important for height adaption
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  // Consistent Elevated Button Style (Handles WidgetState)
  static ButtonStyle elevatedButtonStyle(
    BuildContext context, {
    Color? backgroundColor,
  }) {
    // ... (elevatedButtonStyle remains the same) ...
    final theme = Theme.of(context);
    final defaultBackgroundColor = theme.colorScheme.primary;
    final defaultForegroundColor = theme.colorScheme.onPrimary;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(
        theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      padding: WidgetStateProperty.all(buttonPadding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return (backgroundColor ?? defaultBackgroundColor).withAlpha(127);
        }
        return backgroundColor ?? defaultBackgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        final effectiveBackgroundColor =
            backgroundColor ?? defaultBackgroundColor;
        final defaultContrast =
            ThemeData.estimateBrightnessForColor(effectiveBackgroundColor) ==
                    Brightness.dark
                ? Colors.white
                : Colors.black;
        final effectiveForegroundColor =
            backgroundColor == null ? defaultForegroundColor : defaultContrast;

        if (states.contains(WidgetState.disabled)) {
          return effectiveForegroundColor.withAlpha(178);
        }
        return effectiveForegroundColor;
      }),
      elevation: WidgetStateProperty.resolveWith<double?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) return 0;
        if (states.contains(WidgetState.pressed)) return 4.0;
        return 2.0;
      }),
    );
  }

  // Specific style for Error Buttons (Retry)
  static ButtonStyle errorElevatedButtonStyle(BuildContext context) {
    // ... (errorElevatedButtonStyle remains the same) ...
    final theme = Theme.of(context);
    return elevatedButtonStyle(
      context,
      backgroundColor: theme.colorScheme.errorContainer,
    );
  }

  static Widget buildIconContainer(IconData icon, Color color) {
    // ... (buildIconContainer remains the same) ...
    return Container(
      padding: const EdgeInsets.all(iconPadding),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(iconBorderRadius),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }

  // Helper for Empty State View
  static Widget buildEmptyState(
    BuildContext context,
    IconData icon,
    String message,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: contentPadding.add(
          const EdgeInsets.symmetric(vertical: 20.0),
        ), // Extra vertical padding for empty state
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Important for Column in Center
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
            ),
            const SizedBox(height: modalSpacing * 1.5),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
