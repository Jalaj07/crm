import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Needed for DateFormat
import '../../../constants/travelmanagement_filter_status.dart'; // Adjust path if needed
import '../../../models/hrms/travelmanagement_travel_request.dart'; // Adjust path if needed
import '../../../theme/central_app_theme_color.dart'; // Adjust path if needed

class TravelRequestCard extends StatelessWidget {
  final TravelRequest request;
  final DateFormat dateFormatter; // Required
  final Function(TravelRequest) onTap; // For View Details action
  final Function(TravelRequest) onEdit; // For Edit action
  final Function(TravelRequest) onDelete; // For Delete action

  const TravelRequestCard({
    super.key,
    required this.request,
    required this.dateFormatter, // Required
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // Helper for Label-above-Value items (Used for all details)
  Widget _buildVerticalDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
          ), // Align icon slightly better
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ***** SINGLE, CORRECT build method *****
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme
    final statusTheme =
        theme.extension<StatusColors>(); // Get your custom status colors

    if (statusTheme == null) {
      // Fallback or error if StatusColors extension is not found
      // This shouldn't happen if your theme is set up correctly
      return const Card(
        child: Text('Error: StatusColors theme extension not found.'),
      );
    }

    final Color statusColor = FilterStatus.getColor(
      request.status,
      statusTheme,
    );
    final Color statusBackgroundColor = FilterStatus.getBackgroundColor(
      request.status,
      statusTheme,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      // elevation: 2,
      // shadowColor: Colors.black26,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  // Left: Icon + Request ID
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          request.requestId,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Right: Status Badge
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ), // Uses variable
                  child: Text(
                    request.status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ), // Uses variable
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Details Section (Two Rows, Two Columns) ---
            Row(
              // Row 1
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.flight_takeoff_outlined,
                    'Travel Type',
                    request.travelType,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.description_outlined,
                    'Purpose',
                    request.purpose,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              // Row 2
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.calendar_today_outlined,
                    'Duration',
                    '${request.totalDays} Day${request.totalDays != 1 ? 's' : ''}',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.date_range_outlined,
                    'Requested on',
                    dateFormatter.format(request.date),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Divider(height: 24, thickness: 0.5),

            // --- Action Buttons Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => onTap(request),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Row(
                  // Edit/Delete Icons
                  children: [
                    IconButton(
                      onPressed: () => onEdit(request),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      tooltip: 'Edit',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () => onDelete(request),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      tooltip: 'Delete',
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
  } // ***** End of the single build method *****
} // ***** End of TravelRequestCard class *****
