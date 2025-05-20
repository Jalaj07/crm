// lib/widgets/tourplan/tour_plan_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/tour_plan.dart'; // Ensure path is correct
import '../../../constants/travelmanagement_filter_status.dart'; // Reusing
import '../../../theme/central_app_theme_color.dart'; // Or your theme definition file location

class TourPlanCard extends StatelessWidget {
  final TourPlan plan;
  final DateFormat dateFormatter; // For dates, if needed in this compact view
  final Function(TourPlan) onTap;   // For View Details action
  final Function(TourPlan) onEdit;  // For Edit action
  final Function(TourPlan) onDelete;// For Delete action

  const TourPlanCard({
    super.key,
    required this.plan,
    required this.dateFormatter,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // Helper for Label-above-Value items (reusable within the card)
  Widget _buildVerticalDetail(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0), // Align icon slightly better
          child: Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant.withAlpha(204)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : '-',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface),
                maxLines: 2, // Allow for slightly longer values
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusTheme = theme.extension<StatusColors>();
    if (statusTheme == null) {
      // Fallback or error if StatusColors extension is not found
      return const Card(child: Center(child: Text('Error: Theme not configured.')));
    }

    final Color statusColor = FilterStatus.getColor(plan.status, statusTheme);
    final Color statusBackgroundColor = FilterStatus.getBackgroundColor(plan.status, statusTheme);

    String durationText = '${plan.totalDays} Day${plan.totalDays != 1 ? 's' : ''}';
    if (plan.totalDays <= 0) {
        durationText = "Invalid Dates";
    }


    return Card(
      // margin, elevation, shadowColor, shape come from CardTheme in ThemeData
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), // Standard padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Row: Plan ID and Status Badge ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row( // Icon + Plan ID
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined, // Consistent icon for ID
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          plan.planId, // Display Tour Plan ID
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container( // Status Badge
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    plan.status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Space before details section

            // --- Details Section (Two Rows, Two Columns, mirroring TravelRequestCard style) ---
            // Row 1: Plan Name | Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.text_fields_outlined, // Icon for Plan Name
                    'Plan Name',
                    plan.planName,
                  ),
                ),
                const SizedBox(width: 16), // Spacer between columns
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.location_on_outlined, // Icon for Location
                    'Location',
                    plan.location,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), // Space between rows of details

            // Row 2: Duration | Purpose
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.hourglass_empty_outlined, // Icon for Duration
                    'Duration',
                    durationText,
                  ),
                ),
                const SizedBox(width: 16), // Spacer between columns
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.flag_outlined, // Icon for Purpose
                    'Purpose',
                    plan.purposeOfVisit,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Space before divider

            const Divider(height: 24, thickness: 0.5), // Standard divider

            // --- Action Buttons Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => onTap(plan),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    // foregroundColor: theme.colorScheme.primary, (from theme)
                    // textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600), (from theme)
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Row( // Edit/Delete Icons
                  children: [
                    IconButton(
                      onPressed: () => onEdit(plan),
                      icon: Icon(Icons.edit_outlined, color: theme.colorScheme.secondary, size: 20),
                      tooltip: 'Edit Plan',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () => onDelete(plan),
                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 20),
                      tooltip: 'Delete Plan',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}