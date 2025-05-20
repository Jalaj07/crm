import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/hrms/announced events/announcedevents_office_announcement.dart'; // Adjust path as needed
import '../../../models/hrms/announced events/announcedevents_priority.dart';         // Adjust path as needed

class AnnouncementCard extends StatelessWidget {
  final OfficeAnnouncement announcement;
  final Color categoryColor; // Passed in for background variants
  final IconData categoryIcon;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.categoryColor,
    required this.categoryIcon,
  });

  // Helper to determine text color based on background brightness
  Color _getTextColorForBackground(Color backgroundColor) {
    return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
        ? Colors.white // Use white on dark backgrounds
        : Colors.black87; // Use dark grey on light backgrounds
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderRadius = BorderRadius.circular(16);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface, // Use surface color from theme
        borderRadius: borderRadius,
        // Optional: Add subtle border if desired for separation without shadow
        // border: Border.all(color: theme.dividerColor.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context, borderRadius),
          _buildCardBody(context), // Pass context only
        ],
      ),
    );
  }

  // --- Private helper methods ---

  Widget _buildCardHeader(BuildContext context, BorderRadius borderRadius) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Use a subtle opacity for the category-colored header background
    final headerBackgroundColor = categoryColor.withAlpha(38);

    // Text/Icon color on the header needs contrast. Rely on default theme text color.
    // This assumes the headerBackgroundColor is light enough for default text.
    // If headerBackgroundColor could be dark, you might need _getTextColorForBackground.
// Simpler default

    // Determine icon color based on the solid category color background
    final Color iconColor = _getTextColorForBackground(categoryColor);

    return Container(
      decoration: BoxDecoration(
        color: headerBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: categoryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(categoryIcon, color: iconColor, size: 20), // Use calculated icon color
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: _buildCategoryTag()),
                    if (announcement.priority == Priority.high) const SizedBox(width: 8), // Spacer
                    if (announcement.priority == Priority.high) _buildPriorityTag(context),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.title,
                   // Use TitleMedium style from theme. Color defaults to onSurface, which should work on light bg.
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, // Keep the weight override
                    // color: colorOnHeader, // Using default onSurface, should be fine
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTag() {
     final Color tagTextColor = _getTextColorForBackground(categoryColor);

    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColor, // Raw category color
        borderRadius: BorderRadius.circular(20),
      ),
      // Using direct TextStyle for small tag-specific font size
      child: Text(
        announcement.category,
        style: TextStyle(
          color: tagTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriorityTag(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorColor = colorScheme.error;

    // Determine text color ensuring contrast with errorColor
    final Color tagTextColor = _getTextColorForBackground(errorColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: errorColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high, color: tagTextColor, size: 12),
          const SizedBox(width: 4),
           // Using direct TextStyle for small tag-specific font size
          Text(
            'High Priority',
            style: TextStyle(
              color: tagTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Metadata text style: Use bodySmall and onSurfaceVariant (standard muted color)
    final metadataTextStyle = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );
    const metadataIconSize = 16.0;
    final metadataIconColor = colorScheme.onSurfaceVariant; // Match icon color to muted text color

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), // Reduced bottom padding since button is gone
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement.description,
             // Use bodyMedium style from theme
            style: textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 0.5),
          const SizedBox(height: 8),

          // --- Metadata Section ---
          _buildMetadataRow(
            icon: Icons.calendar_today_outlined,
            iconSize: metadataIconSize,
            iconColor: metadataIconColor,
            text: _formatDateRange(announcement.date, announcement.endDate),
            style: metadataTextStyle,
          ),
          if (announcement.time != null) ...[
            const SizedBox(height: 4),
            _buildMetadataRow(
              icon: Icons.access_time_outlined,
              iconSize: metadataIconSize,
              iconColor: metadataIconColor,
              text: announcement.time!,
              style: metadataTextStyle,
            ),
          ],
          if (announcement.location != null) ...[
            const SizedBox(height: 4),
            _buildMetadataRow(
              icon: Icons.location_on_outlined,
              iconSize: metadataIconSize,
              iconColor: metadataIconColor,
              text: announcement.location!,
              style: metadataTextStyle,
              isExpandable: true,
            ),
          ],
          // --- End Metadata Section ---

          // --- Footer Section ---
          const SizedBox(height: 12), // Spacing before footer
          _buildCardFooter(context, colorScheme, metadataTextStyle), // Pass themed style
          // No extra padding needed at bottom of Padding now
        ],
      ),
    );
  }

  Widget _buildMetadataRow({
    required IconData icon,
    required double iconSize,
    required Color iconColor,
    required String text,
    TextStyle? style,
    bool isExpandable = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.5), // Adjust slightly for alignment
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
        const SizedBox(width: 8),
        if (isExpandable)
          Expanded(child: Text(text, style: style))
        else
          Text(text, style: style),
      ],
    );
  }

  String _formatDateRange(DateTime startDate, DateTime? endDate) {
    // Formatting logic remains the same
    final startFormatted = DateFormat('EEE, MMM d, yyyy').format(startDate);
    if (endDate == null || (endDate.year == startDate.year && endDate.month == startDate.month && endDate.day == startDate.day)) {
      return startFormatted;
    } else {
      final endFormatted = DateFormat('EEE, MMM d, yyyy').format(endDate);
      return '$startFormatted - $endFormatted';
    }
  }

  Widget _buildCardFooter(
    BuildContext context,
    ColorScheme colorScheme,
    TextStyle? metadataTextStyle, // Already themed and muted
  ) {
    return Row(
      // No mainAxisAlignment needed if button is gone, content aligns left
      children: [
        // --- Creator Info ---
        CircleAvatar(
          radius: 12,
          backgroundImage: NetworkImage(announcement.creatorAvatar),
          backgroundColor: colorScheme.surfaceContainerHighest, // Theme bg color for placeholder
            onBackgroundImageError: (exception, stackTrace) {/* Handle error */}
        ),
        const SizedBox(width: 8),
        Expanded( // Allow creator text to take remaining space
          child: Text(
            'Posted by ${announcement.createdBy}',
            style: metadataTextStyle, // Use the passed themed style
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 1,
          ),
        ),

        // --- ACTION BUTTONS REMOVED ---
        // if (isUpcoming && announcement.requiresAction) ... [ ... ] Block Deleted

      ],
    );
  }
}