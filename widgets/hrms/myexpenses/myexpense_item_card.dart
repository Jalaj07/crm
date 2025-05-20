// lib/widgets/expenses/expense_item_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/models/hrms/myexpenses/myexpenses.dart';
import 'package:flutter_development/models/hrms/myexpenses/myexpenses_status.dart';
import 'package:intl/intl.dart';

class ExpenseItemCard extends StatelessWidget {
  final Expense expense;
  final DateFormat dateFormatter;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseItemCard({
    super.key,
    required this.expense,
    required this.dateFormatter,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // MODIFIED: Implemented _buildVerticalDetail
  Widget _buildVerticalDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
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
            color: theme.colorScheme.onSurfaceVariant,
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow:
                    TextOverflow
                        .ellipsis, // Prevent long labels from breaking layout
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty && value != 'N/A'
                    ? value
                    : '-', // Handle empty or "N/A" values
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = expense.status.getColor(context);
    final statusBackgroundColor = expense.status.getBackgroundColor(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          expense.id,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    expense.status.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.calendar_today_outlined,
                    "Date",
                    dateFormatter.format(expense.expenseDate),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.monetization_on_outlined,
                    "Amount",
                    "₹${expense.amount.toStringAsFixed(2)}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.category_outlined,
                    "Type",
                    expense.expenseType,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVerticalDetail(
                    context,
                    Icons.map_outlined,
                    "Visit",
                    expense.visit,
                  ),
                ), // Changed icon and ensure 'visit' value makes sense if N/A
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: theme.colorScheme.secondary,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                        size: 20,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
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
