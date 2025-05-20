// lib/widgets/myteamplan/sales_entry_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/sales_entry.dart'; // SalesEntry model
import '../../../theme/central_app_theme_color.dart'; // For StatusColors for sales status if different

// If SalesStatus uses its own colors, define them or use ThemeExtensions
Color getSalesStatusColor(String status, BuildContext context) {
  final theme = Theme.of(context);
  final statusColors =
      theme
          .extension<
            StatusColors
          >(); // Assuming generic StatusColors can be used

  switch (status) {
    case SalesStatus.approved:
      return statusColors?.approved ?? Colors.green;
    case SalesStatus.inProgress:
      return statusColors?.inProgress ?? Colors.blue;
    case SalesStatus.closedWon:
      return theme.colorScheme.primary; // Example color
    case SalesStatus.closedLost:
      return theme.colorScheme.error; // Example color
    case SalesStatus.onHold:
      return statusColors?.pending ?? Colors.orange;
    default:
      return statusColors?.defaultStatus ?? Colors.grey;
  }
}

Color getSalesStatusBackgroundColor(String status, BuildContext context) {
  final theme = Theme.of(context);
  final statusColors =
      theme
          .extension<
            StatusColors
          >(); // Assuming generic StatusColors can be used
  switch (status) {
    case SalesStatus.approved:
      return statusColors?.approvedBackground ?? Colors.green.withAlpha(30);
    case SalesStatus.inProgress:
      return statusColors?.inProgressBackground ?? Colors.blue.withAlpha(30);
    case SalesStatus.closedWon:
      return theme.colorScheme.primary.withAlpha(30); // Example color
    case SalesStatus.closedLost:
      return theme.colorScheme.error.withAlpha(30); // Example color
    case SalesStatus.onHold:
      return statusColors?.pendingBackground ?? Colors.orange.withAlpha(30);
    default:
      return statusColors?.defaultStatusBackground ?? Colors.grey.withAlpha(20);
  }
}

class SalesEntryCard extends StatelessWidget {
  final SalesEntry salesEntry;
  final DateFormat dateFormatter;
  final VoidCallback? onEdit; // Optional: if you want to edit sales entries
  final VoidCallback? onDelete; // Optional: if you want to delete sales entries

  const SalesEntryCard({
    super.key,
    required this.salesEntry,
    required this.dateFormatter,
    this.onEdit,
    this.onDelete,
  });

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 15, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color cardStatusColor = getSalesStatusColor(
      salesEntry.status,
      context,
    );
    final Color cardStatusBgColor = getSalesStatusBackgroundColor(
      salesEntry.status,
      context,
    );
    final cardBackgroundColor = theme.colorScheme.surfaceContainerLow;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 1.5,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Consistent rounding
        side: BorderSide(
          color: theme.colorScheme.outline.withAlpha(204), // Subtle border
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Sales No: ${salesEntry.salesNumber}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onEdit != null ||
                    onDelete != null) // Show menu only if actions are provided
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: theme.iconTheme.color,
                    ),
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) onEdit!();
                      if (value == 'delete' && onDelete != null) onDelete!();
                    },
                    itemBuilder:
                        (BuildContext context) => <PopupMenuEntry<String>>[
                          if (onEdit != null)
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          if (onDelete != null)
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cardStatusBgColor, // Use specific sales status color
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                salesEntry.status,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cardStatusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 16),
            _buildDetailRow(
              context,
              Icons.person_outline,
              'Customer',
              salesEntry.customerName,
            ),
            _buildDetailRow(
              context,
              Icons.location_on_outlined,
              'Address',
              salesEntry.customerAddress,
            ),
            _buildDetailRow(
              context,
              Icons.calendar_today_outlined,
              'Date',
              dateFormatter.format(salesEntry.date),
            ),
            if (salesEntry.amount != null)
              _buildDetailRow(
                context,
                Icons.attach_money_outlined,
                'Amount',
                NumberFormat.currency(
                  locale: 'en_IN',
                  symbol: '₹',
                ).format(salesEntry.amount),
              ), // Example currency
            if (salesEntry.notes != null && salesEntry.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notes_outlined,
                      size: 15,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Notes: ',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        salesEntry.notes!,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
