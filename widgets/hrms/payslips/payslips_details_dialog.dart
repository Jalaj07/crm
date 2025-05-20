// lib/widgets/payslip_details_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/data/payslips/payslips_pdf_generator.dart';
import 'package:pdf/pdf.dart'; // For PdfPageFormat
import 'package:printing/printing.dart';

import '../../../models/hrms/payslips.dart';
import '../../../utils/payslip_formatting_utils.dart'; // Import formatting utils

// --- Payslip Details Dialog Widget ---
class PayslipDetailsDialog extends StatelessWidget {
  final Payslip payslip;

  const PayslipDetailsDialog({super.key, required this.payslip});

  // --- PDF Action Logic ---
  Future<void> _downloadAndSharePdf(BuildContext context) async {
    // Capture context-dependent objects BEFORE await
    final messenger = ScaffoldMessenger.of(context);
    // Use context.mounted check consistently
    if (!context.mounted) return;

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Generating PDF...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Generate PDF bytes using the dedicated service
      final pdfBytes = await PayslipPdfGenerator.generate(payslip);

      // Ensure context is still valid *before* using Printing package which might need context
      if (!context.mounted) return;

      // Use Printing package to share/preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name:
            'Payslip_${payslip.employeeId}_${payslip.dateTo.replaceAll('/', '-')}.pdf',
      );

      // Optional: Show success message
      // if (context.mounted) { // Check again if necessary
      //   messenger.showSnackBar(const SnackBar(content: Text('PDF Ready!'), backgroundColor: Colors.green));
      // }
    } catch (e, s) {
      // Log detailed error for debugging
      debugPrint('Error generating or sharing PDF: $e\n$s');
      // Check mounted AFTER await BEFORE showing SnackBar
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Error generating PDF: ${e.toString().substring(0, 100)}...',
          ), // Keep msg concise
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isProcessed = payslip.isProcessed;

    return AlertDialog(
      title: const Text(
        'Payslip Details',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      // Use a constrained box if content might become very large
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: _buildDialogContent(
            context,
            isProcessed,
          ), // Delegate content building
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (isProcessed)
          TextButton.icon(
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download PDF'),
            // Call the download method
            onPressed: () => _downloadAndSharePdf(context),
          ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      // Ensures title and actions are not covered by keyboard if a text field were added later
      scrollable:
          false, // Set scrollable on content if needed, not whole dialog
    );
  }

  // Builds the main scrollable content area of the dialog
  Widget _buildDialogContent(BuildContext context, bool isProcessed) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Important for ScrollView + Column
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDetailRow('Name:', payslip.name),
        _buildDetailRow(
          'Employee:',
          '${payslip.employeeName} (${payslip.employeeId})',
        ),
        _buildDetailRow('Period:', '${payslip.dateFrom} - ${payslip.dateTo}'),
        _buildDetailRow('Status:', payslip.status),
        const SizedBox(height: 15),

        if (isProcessed)
          ..._buildBreakdownSections()
        else
          ..._buildUnavailableSection(),
      ],
    );
  }

  // Helper to build Earnings/Deductions/Summary section for processed payslip
  List<Widget> _buildBreakdownSections() {
    return [
      // Earnings Section
      const Text('Earnings:', style: TextStyle(fontWeight: FontWeight.bold)),
      const Divider(),
      ...payslip.earnings.map(
        (item) => _buildDetailRow(
          '  ${item.description}:', // Indent slightly
          FormattingUtils.formatCurrency(item.amount),
        ),
      ),
      const SizedBox(height: 5),
      _buildDetailRow(
        'Total Earnings:',
        FormattingUtils.formatCurrency(payslip.grossEarnings),
        isBold: true,
      ),
      const SizedBox(height: 15),

      // Deductions Section
      const Text('Deductions:', style: TextStyle(fontWeight: FontWeight.bold)),
      const Divider(),
      ...payslip.deductions.map(
        (item) => _buildDetailRow(
          '  ${item.description}:', // Indent slightly
          FormattingUtils.formatCurrency(item.amount),
        ),
      ),
      const SizedBox(height: 5),
      _buildDetailRow(
        'Total Deductions:',
        FormattingUtils.formatCurrency(payslip.totalDeductions),
        isBold: true,
      ),
      const SizedBox(height: 15),

      // Net Salary Summary
      const Divider(thickness: 1.5),
      _buildDetailRow(
        'Net Salary:',
        FormattingUtils.formatCurrency(payslip.netSalary),
        isBold: true,
        fontSize: 16,
      ),
      const Divider(thickness: 1.5),
    ];
  }

  // Helper for when details are unavailable
  List<Widget> _buildUnavailableSection() {
    return [
      const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Detailed breakdown is not available yet.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    ];
  }

  // Helper for layout of each detail row inside the dialog content
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
