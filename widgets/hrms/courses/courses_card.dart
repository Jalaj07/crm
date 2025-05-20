// lib/widgets/course_card.dart

import 'package:flutter/material.dart';
import '../../../models/hrms/courses/courses.dart'; // Import the model
import '../../../constants/courses_layout_constants.dart'; // Import constants

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onViewCourse; // Callback for button press

  const CourseCard({super.key, required this.course, this.onViewCourse});

  // Define a default placeholder image URL (could also be an asset)
  static const String _defaultImageUrl =
      'https://via.placeholder.com/300x120/cccccc/969696.png?text=No+Image';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius), // Use constant
      ),
      clipBehavior: Clip.antiAlias, // Important for clipping the image corners
      margin: EdgeInsets.zero,
      child: Column(
        // Wrap existing content + image in a Column
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Section ---
          _buildCourseImage(course),
          // --- Existing Content Area (with Padding) ---
          Padding(
            padding: const EdgeInsets.all(kCardPadding), // Use constant
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Title ---
                Text(
                  course.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: kVerticalSpacerMedium), // Use constant
                // --- Basic Info (Views & Duration) ---
                _buildInfoRow('Views', '${course.views}', textTheme),
                const SizedBox(height: kVerticalSpacerSmall), // Use constant
                _buildInfoRow('Duration', course.duration, textTheme),
                const SizedBox(height: kVerticalSpacerLarge), // Use constant
                // --- Action Button ---
                ElevatedButton(
                  onPressed: onViewCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        kBorderRadius,
                      ), // Use constant
                    ),
                  ),
                  child: const Text('View course'),
                ),
                const SizedBox(height: kVerticalSpacerLarge), // Use constant
                // --- Stats Row ---
                _buildStatsRow(course, textTheme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Image Builder Helper ---
  Widget _buildCourseImage(Course course) {
    // Use the photoUrl from the course, or the static default if empty/invalid
    final String imageUrl =
        course.photoUrl.isNotEmpty &&
                Uri.tryParse(course.photoUrl)?.hasAbsolutePath == true
            ? course.photoUrl
            : _defaultImageUrl; // Fallback directly if URL looks bad

    return Image.network(
      imageUrl,
      height: 120, // Or use a constant: kCourseImageHeight
      width: double.infinity,
      fit: BoxFit.cover,
      // Error builder handles network issues OR if the final URL still fails
      errorBuilder: (context, error, stackTrace) {
        // Display a visual placeholder on error
        return Container(
          height: 120, // Match the desired image height
          color: Colors.grey[300],
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey[600],
              size: 40,
            ),
          ),
        );
      },
      // Optional: Add a loading builder
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child; // Image loaded
        return Container(
          // Placeholder while loading
          height: 120,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator.adaptive(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          ),
        );
      },
    );
  }

  // --- Internal Build Helpers ---

  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodySmall),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    Course course,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Use the private helper widgets defined below
        Expanded(child: _StatColumn(value: course.contents, label: 'Contents')),
        _Divider(),
        Expanded(
          child: _StatColumn(value: course.attendees, label: 'Attendees'),
        ),
        _Divider(),
        Expanded(child: _StatColumn(value: course.finished, label: 'Finished')),
      ],
    );
  }
}

// --- Private Helper Widgets (Internal to CourseCard) ---

class _StatColumn extends StatelessWidget {
  final int value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: kVerticalSpacerSmall / 2), // Use constant
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withAlpha(76),
      margin: const EdgeInsets.symmetric(horizontal: kVerticalSpacerSmall),
    );
  }
}
