// lib/data/payslips/payslip_repository.dart
import 'package:hive/hive.dart';
import 'package:flutter_development/models/hrms/payslips.dart'; // Adjust path as needed
// Adjust path for mock data if you use it for pre-population
import 'package:flutter_development/data/payslips/payslips_mock_data.dart';

// The box name, ensure it matches main.dart
const String _payslipsBoxName = 'payslipsBox'; // Or import from main.dart if preferred

class PayslipRepository {
  // Get the Hive box instance
  Box<Payslip> get _payslipsBox => Hive.box<Payslip>(_payslipsBoxName);

  // Get all payslips
  List<Payslip> getAllPayslips() {
    final payslips = _payslipsBox.values.toList();
    // Optional: Sort them, e.g., by date or name
    // payslips.sort((a, b) => b.dateTo.compareTo(a.dateTo)); // Example sort
    return payslips;
  }

  // Get a single payslip by its ID
  Payslip? getPayslip(String id) {
    return _payslipsBox.get(id);
  }

  // Add a new payslip
  Future<void> addPayslip(Payslip payslip) async {
    // Since Payslip.id is final, Hive will use it as the key automatically when we put
    await _payslipsBox.put(payslip.id, payslip);
  }

  // Add multiple payslips (e.g., from mock data or API)
  Future<void> addPayslips(List<Payslip> payslips) async {
    final Map<String, Payslip> payslipsMap = {
      for (var p in payslips) p.id: p
    };
    await _payslipsBox.putAll(payslipsMap);
  }

  // Update an existing payslip
  Future<void> updatePayslip(Payslip payslip) async {
    // 'put' will overwrite if the key (payslip.id) already exists
    await _payslipsBox.put(payslip.id, payslip);
    // If 'payslip' instance came directly from the box (e.g., var p = _payslipsBox.get('id');)
    // and you modified its properties, you could also call await p.save();
  }

  // Delete a payslip by its ID
  Future<void> deletePayslip(String id) async {
    await _payslipsBox.delete(id);
  }

  // Clear all payslips (use with caution!)
  Future<void> clearAllPayslips() async {
    await _payslipsBox.clear();
  }

  // Method to populate from mock data if the box is empty
  // This is great for development and ensuring you have data when you first run the app
  Future<void> prepopulateDataIfEmpty() async {
    if (_payslipsBox.isEmpty) {
    //  print("Payslip box is empty. Populating with mock data...");
      // Convert mock data Map<String, dynamic> to List<Payslip>
      final payslipsFromMock = mockPayslipData
          .map((data) => Payslip.fromJson(data))
          .toList();
      await addPayslips(payslipsFromMock);
    //  print("${payslipsFromMock.length} payslips added from mock data.");
    } else {
    //  print("Payslip box already has data. Skipping pre-population.");
    }
  }

  // Optional: Listen to changes
  // Stream<BoxEvent> watchPayslips() {
  //   return _payslipsBox.watch();
  // }
}