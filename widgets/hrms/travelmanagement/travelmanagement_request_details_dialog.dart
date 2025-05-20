import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Adjust import paths based on your project structure
import '../../../constants/travelmanagement_filter_status.dart';
import '../../../models/hrms/travelmanagement_travel_request.dart';
import '../../../theme/central_app_theme_color.dart'; // Adjust path if needed

class TravelRequestDetailsDialog extends StatelessWidget {
  final TravelRequest request;
  final DateFormat dateFormatter;

  const TravelRequestDetailsDialog({
    required this.request,
    required this.dateFormatter,
    super.key, // Added key
  });

  Widget _buildDetailRow(
    BuildContext context, {
    IconData? icon,
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child:
                icon != null
                    ? Icon(icon, size: 18, color: colorScheme.primary)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  TextSpan(
                    text: value.isNotEmpty ? value : '-',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StatusColors? statusTheme = theme.extension<StatusColors>();

    if (statusTheme == null) {
      // Fallback for safety, though your theme setup should provide it
      return const AlertDialog(
        content: Text('Error: Theme not configured correctly.'),
      );
    }

    final Color statusColor = FilterStatus.getColor(
      request.status,
      statusTheme,
    );
    final Color statusBgColor = FilterStatus.getBackgroundColor(
      request.status,
      statusTheme,
    );

    return AlertDialog(
   //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline_rounded, size: 24),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Request Details',
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              request.status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListBody(
          children: <Widget>[
            const Divider(height: 20),
            _buildDetailRow(
              context,
              icon: Icons.vpn_key_outlined,
              label: 'Request ID',
              value: request.requestId,
            ),
            _buildDetailRow(
              context,
              icon: Icons.person_outline,
              label: 'Requester/Dept',
              value: request.name,
            ),
            const Divider(height: 15, indent: 36),
            _buildDetailRow(
              context,
              icon: Icons.public_outlined,
              label: 'Travel Type',
              value: request.travelType,
            ),
            _buildDetailRow(
              context,
              icon: Icons.badge_outlined,
              label: 'Traveller Type',
              value: request.travellerType,
            ),
            _buildDetailRow(
              context,
              icon: Icons.calendar_today_outlined,
              label: 'Duration',
              value:
                  '${request.totalDays} Day${request.totalDays != 1 ? 's' : ''}',
            ),
            const Divider(height: 15, indent: 36),
            _buildDetailRow(
              context,
              icon: Icons.notes_outlined,
              label: 'Purpose',
              value: request.purpose,
            ),
            _buildDetailRow(
              context,
              icon: Icons.event_available_outlined,
              label: 'Requested On',
              value: dateFormatter.format(request.date),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
