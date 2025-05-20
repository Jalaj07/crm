import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';

// Widget for displaying stats/actions with an icon
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final VoidCallback? onTap;

  const StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
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

    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      // Use margin for spacing between cards
      margin: EdgeInsets.only(
        left: kSectionPaddingHorizontal,
        right: kSectionPaddingHorizontal,
        bottom: kCardMargin * 1.5,
      ),
      clipBehavior: Clip.antiAlias,
      // Use themed surface color with elevation tint
      color: ElevationOverlay.applySurfaceTint(
        theme.colorScheme.surface,
        theme.colorScheme.surfaceTint,
        kCardElevation,
      ),
      child: InkWell(
        onTap: canTap ? onTap : null,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        splashColor:
            canTap
                ? iconColor.withAlpha(25)
                : Colors.transparent, // Use icon color for feedback
        highlightColor: canTap ? iconColor.withAlpha(13) : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kCardPadding,
            vertical: kCardPadding * 0.85,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Background and Icon
              Container(
                width: kIconBackgroundSize,
                height: kIconBackgroundSize,
                padding: const EdgeInsets.all(
                  kIconBackgroundPadding,
                ), // Use constant
                decoration: BoxDecoration(
                  // Use icon color with low opacity for background
                  color: iconColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(kSmallBorderRadius),
                ),
                child: Icon(icon, color: iconColor, size: kIconSize),
              ),
              const SizedBox(width: kItemSpacing),
              // Title and Value Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kTinyItemSpacing * 0.5),
                    Text(
                      value,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            isNA
                                ? colorScheme.onSurfaceVariant.withAlpha(153)
                                : colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow Indicator (always visible but dimmed if not tappable)
              Padding(
                padding: const EdgeInsets.only(left: kSmallItemSpacing),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color:
                      canTap
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant.withAlpha(
                            76,
                          ), // Dim if not tappable
                  size: kArrowIconSize * 0.9, // Slightly smaller arrow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
