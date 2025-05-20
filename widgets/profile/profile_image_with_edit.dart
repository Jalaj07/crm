import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';

// Widget for the profile image with gradient border and edit button
class ProfileImageWithEdit extends StatelessWidget {
  final String imageUrl;
  final Color statusColor;
  final VoidCallback onEditTap;

  const ProfileImageWithEdit({
    required this.imageUrl,
    required this.statusColor,
    required this.onEditTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Outer container for gradient border
        Container(
          padding: const EdgeInsets.all(3.0), // Border thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              // Apply gradient border
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primary, statusColor.withAlpha(217)],
              stops: const [0.0, 1.0], // Smooth transition
            ),
          ),
          // Inner container clips the image and provides background
          child: ClipOval(
            child: Container(
              width: kProfileImageSize,
              height: kProfileImageSize,
              color:
                  colorScheme
                      .surfaceContainerHighest, // Background for loading/error states
              // Network image with loading and error handling
              child: Image.network(
                imageUrl,
                width: kProfileImageSize,
                height: kProfileImageSize,
                fit: BoxFit.cover, // Ensure image fills the circle
                // Error placeholder icon
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      Icons.person_outline_rounded,
                      size: kProfileImageSize * 0.5,
                      color: colorScheme.onSurfaceVariant.withAlpha(127),
                    ),
                // Loading indicator
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Return image when loaded
                  }
                  // Show progress indicator while loading
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2.5,
                      // Calculate progress value if possible
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null, // Indeterminate otherwise
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        // Edit Button overlay
        Positioned(
          right: 2,
          bottom: 2, // Offset slightly from edge
          child: Material(
            // Provides elevation and ink splash effects
            type: MaterialType.circle, // Ensures circular shape for ink splash
            color: colorScheme.primary,
            elevation: kCardElevation + 1.5, // Higher elevation for visibility
            shadowColor: Colors.black.withAlpha(102), // Add shadow
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onEditTap, // Trigger callback on tap
              splashColor: colorScheme.onPrimary.withAlpha(
                76,
              ), // Visual feedback on tap
              child: Padding(
                padding: const EdgeInsets.all(
                  kTinyItemSpacing + 2.0,
                ), // Padding inside the button
                child: Icon(
                  Icons.edit_outlined,
                  color: colorScheme.onPrimary,
                  size: kArrowIconSize * 1.15,
                ), // Slightly larger icon
              ),
            ),
          ),
        ),
      ],
    );
  }
}
