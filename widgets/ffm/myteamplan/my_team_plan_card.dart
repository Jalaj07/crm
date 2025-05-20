// lib/widgets/myteamplan/my_team_plan_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/my_team_plan.dart'; // Path to MyTeamPlan model
import '../../../constants/travelmanagement_filter_status.dart';
import '../../../theme/central_app_theme_color.dart';

class MyTeamPlanCard extends StatelessWidget {
  final MyTeamPlan plan;
  final DateFormat dateFormatter;
  final Function(MyTeamPlan) onTap;
  final Function(MyTeamPlan) onEdit;
  final Function(MyTeamPlan) onDelete;

  const MyTeamPlanCard({
    super.key,
    required this.plan,
    required this.dateFormatter,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Widget _buildVerticalDetail(BuildContext context, IconData icon, String label, String value) {
    // ... (Same as in previous TourPlanCard)
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
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
                maxLines: 2,
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
    // ... (Same as previous TourPlanCard, just ensure `plan` is MyTeamPlan type)
    final theme = Theme.of(context);
    final statusTheme = theme.extension<StatusColors>();
    if (statusTheme == null) return const Card(child: Center(child: Text('Error: Theme not configured.')));

    final Color statusColor = FilterStatus.getColor(plan.status, statusTheme);
    final Color statusBackgroundColor = FilterStatus.getBackgroundColor(plan.status, statusTheme);
    String durationText = '${plan.totalDays} Day${plan.totalDays != 1 ? 's' : ''}';
    if (plan.totalDays <= 0) durationText = "Invalid Dates";

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row( // Header
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.assignment_ind_outlined, size: 18, color: theme.colorScheme.primary), // Icon for Plan ID
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(plan.planId, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                Container( // Status Badge
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBackgroundColor, borderRadius: BorderRadius.circular(16)),
                  child: Text(plan.status, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: statusColor)),
                ),
              ],
            ),
            if (plan.assignedTo != null && plan.assignedTo!.isNotEmpty) // Show assigned To if available
                Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                    "Assigned To: ${plan.assignedTo}",
                    style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: theme.colorScheme.onSurfaceVariant),
                    ),
                ),
            const SizedBox(height: 10),
            // Details Section (2x2 Grid)
            Row(
              children: [
                Expanded(child: _buildVerticalDetail(context, Icons.label_outline, 'Plan Name', plan.planName)),
                const SizedBox(width: 16),
                Expanded(child: _buildVerticalDetail(context, Icons.location_on_outlined, 'Location', plan.location)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildVerticalDetail(context, Icons.schedule_outlined, 'Duration', durationText)),
                const SizedBox(width: 16),
                Expanded(child: _buildVerticalDetail(context, Icons.flag_circle_outlined, 'Purpose', plan.purposeOfVisit)),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 24, thickness: 0.5),
            // Action Buttons
            Row( /* ... (Same action buttons as TourPlanCard) ... */
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => onTap(plan),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Details'),
                   style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => onEdit(plan),
                      icon: Icon(Icons.edit_outlined, color: theme.colorScheme.secondary, size: 20),
                      tooltip: 'Edit Plan', constraints: const BoxConstraints(), padding: const EdgeInsets.all(8), visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () => onDelete(plan),
                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 20),
                      tooltip: 'Delete Plan', constraints: const BoxConstraints(), padding: const EdgeInsets.all(8), visualDensity: VisualDensity.compact,
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