import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';
import 'profile_image_with_edit.dart'; // Import the ProfileImage widget

// Builds the top profile header card
class ProfileHeaderSection extends StatelessWidget {
  final String name;
  final String jobTitleOrDept;
  final String status;
  final Color statusColor;
  final String profileImageUrl;
  final VoidCallback onEditProfileTap;

  const ProfileHeaderSection({
    required this.name,
    required this.jobTitleOrDept,
    required this.status,
    required this.statusColor,
    required this.profileImageUrl,
    required this.onEditProfileTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kSectionPaddingHorizontal,
      ),
      child: Card(
        elevation: kCardElevation + 0.5, // Slightly higher elevation for header
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        margin: EdgeInsets.zero, // Use padding instead of margin
        clipBehavior: Clip.antiAlias,
        // Apply elevation overlay tint based on theme
        color: ElevationOverlay.applySurfaceTint(
          theme.colorScheme.surface,
          theme.colorScheme.surfaceTint,
          kCardElevation + 0.5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            kCardPadding * 1.1,
          ), // More padding in header
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image + Edit Button
              ProfileImageWithEdit(
                // Use the imported widget
                imageUrl: profileImageUrl,
                statusColor: statusColor,
                onEditTap: onEditProfileTap, // Pass the callback
              ),
              const SizedBox(width: kItemSpacing),
              // Name, Title, Status Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Constrain height
                  children: [
                    Text(
                      name,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kTinyItemSpacing),
                    Text(
                      jobTitleOrDept,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kSmallItemSpacing),
                    _buildStatusIndicator(
                      status,
                      statusColor,
                      theme,
                    ), // Keep internal helper or make separate widget
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the status indicator row (kept internal to this section)
  Widget _buildStatusIndicator(
    String status,
    Color statusColor,
    ThemeData theme,
  ) {
    return Row(
      children: [
        // Circle indicator with a subtle border
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: ElevationOverlay.applySurfaceTint(
                theme.cardColor,
                theme.colorScheme.surfaceTint,
                1,
              ),
              width: 1.5,
            ), // Border matches card bg slightly elevated
          ),
        ),
        const SizedBox(width: 6),
        // Status text
        Text(
          status,
          style: theme.textTheme.labelMedium?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
