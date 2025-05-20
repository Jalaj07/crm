// lib/screens/employee_reports/widgets/payroll_summary_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/payslip_formatting_utils.dart';

class PayrollSummarySection extends StatelessWidget {
  const PayrollSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
    String nextPayDateStr = DateFormat('MMMM d, yyyy').format(endOfMonth);
    String nextPayAmountStr = FormattingUtils.formatCurrency(
      3450.00,
    ); // Sample amount in rupees

    // Define colors locally as they are specific to this widget layout
    Color textColor = Colors.purple[900] ?? Colors.purple;
    Color lightTextColor = (Colors.purple[900] ?? Colors.purple).withAlpha(204);
    Color borderColor = Colors.purple[200] ?? Colors.purple.shade200;
    Color gradientStart = Colors.purple.shade100;
    Color gradientEnd = Colors.purple.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Payroll',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Pay Date',
                      style: TextStyle(fontSize: 12, color: lightTextColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextPayDateStr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Estimated Amount',
                      style: TextStyle(fontSize: 12, color: lightTextColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextPayAmountStr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
