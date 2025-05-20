// lib/services/payslip_pdf_generator.dart

import 'dart:typed_data'; // Explicit import for Uint8List
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // For PdfGoogleFonts

import '../../models/hrms/payslips.dart';
import '../../utils/payslip_formatting_utils.dart';

// --- PDF Generation Service ---
class PayslipPdfGenerator {
  static Future<Uint8List> generate(Payslip payslip) async {
    final pdf = pw.Document();

    // Load fonts once
    final baseFont = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    // Define styles
    final baseStyle = pw.TextStyle(font: baseFont, fontSize: 10);
    final boldStyle = pw.TextStyle(font: boldFont, fontSize: 10);
    final titleStyle = pw.TextStyle(font: boldFont, fontSize: 18);
    final headerStyle = pw.TextStyle(font: boldFont, fontSize: 12);
    final tableHeaderStyle = pw.TextStyle(
      font: boldFont,
      color: PdfColors.white,
      fontSize: 10,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- Header ---
              pw.Center(child: pw.Text('Payslip', style: titleStyle)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Employee:', style: boldStyle),
                      pw.Text(
                        '${payslip.employeeName} (${payslip.employeeId})',
                        style: baseStyle,
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Pay Period:', style: boldStyle),
                      pw.Text(
                        '${payslip.dateFrom} - ${payslip.dateTo}',
                        style: baseStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.Divider(thickness: 1, height: 25),

              // --- Earnings ---
              pw.Text('Earnings', style: headerStyle),
              pw.SizedBox(height: 8),
              _buildPdfTable(
                context: pdfContext,
                headers: ['Description', 'Amount'],
                data:
                    payslip.earnings
                        .map(
                          (e) => [
                            e.description,
                            FormattingUtils.formatCurrency(e.amount),
                          ],
                        )
                        .toList(),
                headerStyle: tableHeaderStyle,
                cellStyle: baseStyle,
              ),
              pw.SizedBox(height: 8),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total Earnings: ${FormattingUtils.formatCurrency(payslip.grossEarnings)}',
                  style: boldStyle.copyWith(fontSize: 11),
                ),
              ),
              pw.SizedBox(height: 20),

              // --- Deductions ---
              pw.Text('Deductions', style: headerStyle),
              pw.SizedBox(height: 8),
              _buildPdfTable(
                context: pdfContext,
                headers: ['Description', 'Amount'],
                data:
                    payslip.deductions
                        .map(
                          (d) => [
                            d.description,
                            FormattingUtils.formatCurrency(d.amount),
                          ],
                        )
                        .toList(),
                headerStyle: tableHeaderStyle,
                cellStyle: baseStyle,
              ),
              pw.SizedBox(height: 8),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total Deductions: ${FormattingUtils.formatCurrency(payslip.totalDeductions)}',
                  style: boldStyle.copyWith(fontSize: 11),
                ),
              ),
              pw.Divider(thickness: 1, height: 25),

              // --- Summary ---
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  child: pw.Text(
                    'Net Salary: ${FormattingUtils.formatCurrency(payslip.netSalary)}',
                    style: boldStyle.copyWith(fontSize: 13),
                  ),
                ),
              ),
              pw.Spacer(), // Pushes footer to bottom
              // --- Footer ---
              pw.Divider(color: PdfColors.grey),
              pw.Center(
                child: pw.Text(
                  'Generated on: ${DateTime.now().toLocal().toString().substring(0, 16)} - Company Name Placeholder',
                  style: baseStyle.copyWith(
                    color: PdfColors.grey600,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Helper remains private static within this service class
  static pw.Widget _buildPdfTable({
    required pw.Context context,
    required List<String> headers,
    required List<List<String>> data,
    required pw.TextStyle headerStyle,
    required pw.TextStyle cellStyle,
  }) {
    return pw.TableHelper.fromTextArray(
      context: context,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle: headerStyle,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft, // Description
        1: pw.Alignment.centerRight, // Amount
      },
      cellStyle: cellStyle,
      columnWidths: {
        0: const pw.FlexColumnWidth(3), // Description wider
        1: const pw.FlexColumnWidth(2), // Amount narrower
      },
    );
  }
}
