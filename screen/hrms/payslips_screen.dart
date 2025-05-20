// lib/screens/payslip_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_development/data/payslips/payslip_repository.dart';
import '../../models/hrms/payslips.dart';
import '../../widgets/hrms/payslips/payslips_card.dart';

// --- Main Page Widget ---
class PayslipPage extends StatefulWidget {
  const PayslipPage({super.key});

  @override
  State<PayslipPage> createState() => _PayslipPageState();
}

class _PayslipPageState extends State<PayslipPage> {
  final PayslipRepository _payslipRepository = PayslipRepository();
  List<Payslip> _payslips = [];
  bool _isLoading = true;
  bool _mounted = true; // Keep track of mounted state

  @override
  void initState() {
    super.initState();
    _mounted = true;
    _loadPayslips();
  }

  @override
  void dispose() {
    _mounted = false; // Set to false when disposed
    super.dispose();
  }

  // Helper to safely update state only if the widget is still mounted
  void _safeSetState(VoidCallback fn) {
    if (_mounted) {
      setState(fn);
    }
  }

  Future<void> _loadPayslips() async {
    _safeSetState(() => _isLoading = true);
    // Simulate network delay (replace with actual API call)
    await Future.delayed(const Duration(seconds: 1));

    // Use the mock data imported from the data file
    // Ensure your actual data fetching handles errors gracefully
    try {
      // First, ensure data is pre-populated if needed (e.g., on first app run)
      // This should ideally be done once, perhaps after opening the box in main.dart
      // or checked within the repository itself. For simplicity here:
      await _payslipRepository.prepopulateDataIfEmpty();

      // Fetch payslips from the local Hive database
      final fetchedPayslips = _payslipRepository.getAllPayslips();

      // Simulate a small delay if you want to mimic network or just for smoother UI update
      // await Future.delayed(const Duration(milliseconds: 300));

      _safeSetState(() {
        _payslips = fetchedPayslips;
        _isLoading = false;
      });
    } catch (e) {
      if (!_mounted) return;
      //print("Error loading payslips: $e"); // Log the error
      _safeSetState(() {
        _isLoading = false;
        _payslips = [];
        // Optionally show an error message to the user
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not load payslips.")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_payslips.isEmpty) {
      // Consider adding a button to retry fetching here
      bodyContent = const Center(child: Text('No payslips found.'));
    } else {
      bodyContent = ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _payslips.length,
        itemBuilder: (context, index) {
          // Use the dedicated PayslipCard widget (ensure it's imported)
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PayslipCard(payslip: _payslips[index]),
          );
        },
      );
    }
    // This widget is intended to be the body of a Scaffold
    return bodyContent;
  }
}
