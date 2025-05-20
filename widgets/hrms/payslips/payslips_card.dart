// lib/widgets/payslip_card.dart

import 'package:flutter/material.dart';

import '../../../models/hrms/payslips.dart';
import 'payslips_details_dialog.dart'; // Import the dialog widget

// --- Payslip Card Widget ---
class PayslipCard extends StatelessWidget {
  final Payslip payslip;

  const PayslipCard({super.key, required this.payslip});

  // --- Triggers Dialog ---
  void _showPayslipDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use the dedicated Dialog widget
        return PayslipDetailsDialog(payslip: payslip);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isProcessed = payslip.isProcessed;
    final Color statusColor =
        isProcessed ? Colors.blue.shade700 : Colors.grey.shade500;
    final Color lightStatusColor =
        isProcessed ? Colors.blue.shade50 : Colors.grey.shade100;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _showPayslipDetails(context), // Use the method
      borderRadius: BorderRadius.circular(8),
      child: Card(
        // Use CardTheme from main.dart theme for elevation/shape if consistent style is desired
        // elevation: 3,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias, // Important for the side color bar
        child: IntrinsicHeight(
          // Ensures Row children stretch vertically
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Indicator Bar
              Container(
                width: 10,
                decoration: BoxDecoration(color: statusColor),
              ),
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payslip.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Employee: ${payslip.employeeName}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Date Row Helper
                      _buildDateRow(context, payslip.dateFrom, payslip.dateTo),
                      const SizedBox(height: 12),
                      // Status Chip
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: lightStatusColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            payslip.status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper specific to the card's layout needs
  Widget _buildDateRow(BuildContext context, String from, String to) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date From',
                style: textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                from,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date To',
                style: textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                to,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
