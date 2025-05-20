import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';

// Widget for displaying info items in a row
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const InfoCard({
    required this.title,
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bool isNA = value == kNotAvailable;
    final bool canTap = onTap != null && !isNA;

    return Expanded(
      // Takes available space in the Row
      child: Card(
        elevation: 0, // No elevation for inner cards, rely on background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSmallBorderRadius),
          // Subtle border to distinguish cards
          side: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(76),
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: kCardMargin / 2,
          vertical: kCardMargin / 3,
        ),
        clipBehavior: Clip.antiAlias, // Clip content
        color:
            theme
                .colorScheme
                .surfaceContainerLowest, // Subtle distinct background
        child: InkWell(
          // Makes the card tappable
          onTap:
              canTap
                  ? onTap
                  : null, // Only tappable if action exists and value is not N/A
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSmallBorderRadius),
          ),
          splashColor:
              canTap
                  ? colorScheme.primary.withAlpha(25)
                  : Colors.transparent, // Tap feedback
          highlightColor:
              canTap ? colorScheme.primary.withAlpha(13) : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kCardPadding * 0.8,
              vertical: kCardPadding * 0.7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Fit content vertically
              children: [
                // Title Text (Label)
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis, // Prevent long titles from breaking layout
                ),
                const SizedBox(height: kTinyItemSpacing / 2), // Minimal space
                // Value Text
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    // Dim text if value is 'N/A'
                    color:
                        isNA
                            ? colorScheme.onSurfaceVariant.withAlpha(153)
                            : colorScheme.onSurface,
                    height: 1.3, // Improve line spacing for multi-line values
                  ),
                  maxLines: 2, // Allow value to wrap to a second line
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
