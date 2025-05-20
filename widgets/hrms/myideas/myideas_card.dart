import 'package:flutter/material.dart';
import 'package:flutter_development/constants/myideas_constants.dart';
import 'package:flutter_development/models/hrms/myideas.dart';
import 'package:intl/intl.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  const IdeaCard({super.key, required this.idea});

  Widget _buildStatusChip(Color statusColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: statusColor.withAlpha(17),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      idea.status,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: statusColor,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final statusColor = AppConstants.getStatusColor(idea.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    idea.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.itemSpacing),
                _buildStatusChip(statusColor),
              ],
            ),
            const SizedBox(height: AppConstants.itemSpacing),
            Text(
              idea.description,
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.sectionSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(idea.category),
                  labelStyle: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                  backgroundColor: colorScheme.primary.withAlpha(25),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  side: BorderSide.none,
                ),
                Text(
                  DateFormat.yMMMd().format(idea.createdAt),
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
