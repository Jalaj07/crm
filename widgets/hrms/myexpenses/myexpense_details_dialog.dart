// lib/widgets/expenses/expense_details_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/models/hrms/myexpenses/myexpenses.dart';
import 'package:flutter_development/models/hrms/myexpenses/myexpenses_status.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsDialog extends StatelessWidget {
  final Expense expense;
  final DateFormat dateFormatter;

  const ExpenseDetailsDialog({
    super.key,
    required this.expense,
    required this.dateFormatter,
  });

  // MODIFIED: Implemented _buildDetailRow
  Widget _buildDetailRow(
    BuildContext context, {
    IconData? icon,
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ), // Added padding argument
      child: Row(
        // Added child for Padding
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
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ), // Ensure base style has color
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  TextSpan(
                    text:
                        value.isNotEmpty && value != "N/A"
                            ? value
                            : '-', // Handle "N/A" for value
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
    final theme = Theme.of(context); // Define theme
    // final statusColor = expense.status.getColor(context); // Called in badge
    // final statusBackgroundColor = expense.status.getBackgroundColor(context); // Called in badge

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      actionsPadding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        10,
      ), // Added actions padding for consistency
      // MODIFIED: Implemented title Row
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 24,
                ), // Expense icon
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Expense Details',
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
              color: expense.status.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              expense.status.displayName,
              style: TextStyle(
                color: expense.status.getColor(context),
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
              label: "ID",
              value: expense.id,
            ),
            _buildDetailRow(
              context,
              icon: Icons.description_outlined,
              label: "Description",
              value: expense.description,
            ),
            _buildDetailRow(
              context,
              icon: Icons.calendar_today_outlined,
              label: "Date",
              value: dateFormatter.format(expense.expenseDate),
            ),
            _buildDetailRow(
              context,
              icon: Icons.person_outline,
              label: "Employee",
              value: expense.employeeName,
            ),
            const Divider(
              height: 15,
              indent: 36,
            ), // Indent divider if details below are related
            _buildDetailRow(
              context,
              icon: Icons.category_outlined,
              label: "Type",
              value: expense.expenseType,
            ),
            _buildDetailRow(
              context,
              icon: Icons.monetization_on_outlined,
              label: "Amount",
              value: "₹${expense.amount.toStringAsFixed(2)}",
            ),
            if (expense.visit.isNotEmpty && expense.visit != "N/A")
              _buildDetailRow(
                context,
                icon: Icons.location_on_outlined,
                label: "Visit Location",
                value: expense.visit,
              ),
            if (expense.visitSchedule.isNotEmpty &&
                expense.visitSchedule != "N/A")
              _buildDetailRow(
                context,
                icon: Icons.schedule_outlined,
                label: "Visit Schedule",
                value: expense.visitSchedule,
              ),
            if (expense.distanceCovered > 0)
              _buildDetailRow(
                context,
                icon: Icons.directions_car_outlined,
                label: "Distance",
                value: "${expense.distanceCovered.toStringAsFixed(1)} km",
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
