// FILE: lib/screens/leave_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/hrms/leave_models.dart'; // Path should point to your models file
// Import Widgets
import '../../widgets/hrms/leave/leave_balance_display.dart'; // Adjust paths as needed
import '../../widgets/hrms/leave/leave_filter_header.dart';
import '../../widgets/hrms/leave/leave_list_view.dart';
import '../../widgets/hrms/leave/leave_details_sheet_content.dart';
import '../../widgets/hrms/leave/leave_balance_sheet_content.dart';
import '../../widgets/hrms/leave/apply_leave_sheet_content.dart';
import '../../widgets/hrms/leave/edit_leave_sheet_content.dart';
// Import Dialog Utility
import '../../widgets/hrms/leave/leave_dialogs/leave_cancel_confirmation_dialog.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  // --- State ---
  int leaveBalance = 12; // Fetch from service
  // Ensure leaveHistory uses the LeaveRecord type from leave_models.dart
  List<LeaveRecord> leaveHistory = _getSampleLeaveData(); // Fetch from service

  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Pending', 'Approved', 'Rejected'];
  final DateFormat dateFormat = DateFormat('d MMM'); // Keep formatting consistent

  // --- Computed State ---
  List<LeaveRecord> get filteredLeaveHistory {
    List<LeaveRecord> filtered;
    if (_selectedFilter == 'All') {
      filtered = [...leaveHistory]; // Create a copy
    } else {
      // Map string filter to the LeaveStatus enum FROM THE MODELS FILE
      final statusMap = {
        'Pending': LeaveStatus.pending,
        'Approved': LeaveStatus.approved,
        'Rejected': LeaveStatus.rejected,
      };
      final targetStatus = statusMap[_selectedFilter];
      // Filter using the status property FROM THE MODELS FILE definition
      filtered = leaveHistory.where((leave) => leave.status == targetStatus).toList();
    }
    // Sort using the startDate property FROM THE MODELS FILE definition
    filtered.sort((a, b) => b.startDate.compareTo(a.startDate));
    return filtered;
  }

  // --- UI Build Method ---
  @override
  Widget build(BuildContext context) {
    // Access theme for overrides if needed, but most is handled by component themes
    Theme.of(context);
    // final colorScheme = theme.colorScheme; // Use if needed for specific overrides

    return Scaffold(
      // backgroundColor is handled by scaffoldBackgroundColor in ThemeData
      body: Column(
        children: [
          // 1. Balance Display Widget
          LeaveBalanceDisplay(
            leaveBalance: leaveBalance,
            onInfoTap: () => _showLeaveBalanceDetails(context),
          ),
          const Divider(), // Uses DividerThemeData defined centrally

          // 2. Filter Header Widget
          LeaveFilterHeader(
            selectedFilter: _selectedFilter,
            filterOptions: _filterOptions,
            onFilterChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedFilter = newValue;
                });
              }
            },
          ),

          // 3. Leave List Widget
          // Ensure LeaveListView expects List<LeaveRecord> from leave_models.dart
          LeaveListView(
            leaveRecords: filteredLeaveHistory, // Use the getter
            dateFormat: dateFormat,
            currentFilter: _selectedFilter, // Pass filter for empty message
            // Ensure onItemTap expects LeaveRecord from leave_models.dart
            onItemTap: (leave) => _showLeaveDetails(context, leave),
          ),
        ],
      ),
      // FloatingActionButton uses FloatingActionButtonThemeData
      floatingActionButton: FloatingActionButton(
        tooltip: 'Apply for Leave',
        child: const Icon(Icons.add),
        onPressed: () => _showApplyLeaveBottomSheet(context),
      ),
    );
  }

  // --- Modal & Dialog Trigger Methods ---

  void _showLeaveBalanceDetails(BuildContext context) {
    final Map<String, int> balanceBreakdown = {
      'Annual Leave': 7, 'Sick Leave': 3, 'Casual Leave': 2,
    };
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Shape & Background handled by BottomSheetThemeData
      builder: (_) => LeaveBalanceSheetContent(balanceBreakdown: balanceBreakdown),
    );
  }

  // Ensure 'leave' parameter is LeaveRecord from leave_models.dart
  void _showLeaveDetails(BuildContext context, LeaveRecord leave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Shape & Background handled by BottomSheetThemeData
      // Ensure LeaveDetailsSheetContent expects LeaveRecord from leave_models.dart
      builder: (_) => LeaveDetailsSheetContent(
        leaveRecord: leave,
        dateFormat: dateFormat,
        // Access leave.status from the correctly imported model
        onEdit: leave.status == LeaveStatus.pending
                ? () { Navigator.pop(context); _showEditLeaveBottomSheet(context, leave); }
                : null,
        onCancel: leave.status == LeaveStatus.pending
                ? () { Navigator.pop(context); _handleCancelLeave(context, leave); }
                : null,
      ),
    );
  }

  void _showApplyLeaveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Shape & Background handled by BottomSheetThemeData
      // Ensure ApplyLeaveSheetContent's onSubmit provides LeaveRecord from leave_models.dart
      builder: (_) => ApplyLeaveSheetContent(
        dateFormat: dateFormat,
        onSubmit: (newRecord) { // newRecord must be type from leave_models.dart
          setState(() { leaveHistory.add(newRecord); });
          Navigator.pop(context); // Close the sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Leave request submitted successfully'),
              // Success styling: Use theme primary or default SnackBar theme
              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(229), // Example override
              // Or rely purely on SnackBarThemeData
            ),
          );
        },
      ),
    );
  }

  // Ensure 'leave' parameter is LeaveRecord from leave_models.dart
  void _showEditLeaveBottomSheet(BuildContext context, LeaveRecord leave) {
    final recordIndex = leaveHistory.indexWhere((item) => item == leave);
    if (recordIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error: Cannot find request to edit.'),
          backgroundColor: Theme.of(context).colorScheme.error, // Use error color from scheme
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Shape & Background handled by BottomSheetThemeData
      // Ensure EditLeaveSheetContent expects & provides LeaveRecord from leave_models.dart
      builder: (_) => EditLeaveSheetContent(
        originalLeaveRecord: leaveHistory[recordIndex], // Must be type from leave_models.dart
        dateFormat: dateFormat,
        onUpdate: (updatedRecord) { // updatedRecord must be type from leave_models.dart
          setState(() { leaveHistory[recordIndex] = updatedRecord; });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: const Text('Leave request updated successfully'),
              // Success styling
              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(229), // Example
            ),
          );
        },
      ),
    );
  }

  // Ensure 'leave' parameter is LeaveRecord from leave_models.dart
  void _handleCancelLeave(BuildContext context, LeaveRecord leave) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme; // Get scheme for snackbar

    final bool? confirmed = await showCancelLeaveConfirmationDialog(context);
    if (!mounted) return;

    if (confirmed == true) {
      // Ensure item is correctly identified and removed
      setState(() { leaveHistory.removeWhere((item) => item == leave); });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Leave request cancelled successfully'),
          // Warning/Neutral styling for cancel: Use secondary? Or slightly modified error?
           backgroundColor: colorScheme.secondary, // Using secondary as the "warning" color
           // OR: backgroundColor: colorScheme.error.withOpacity(0.8),
        ),
      );
    }
  }

  // --- Static Sample Data (Replace with Service Call) ---
  // Ensure this returns List<LeaveRecord> using the DEFINITION FROM THE MODELS FILE
  static List<LeaveRecord> _getSampleLeaveData() {
    // Make sure DateTime, DateRange, and LeaveStatus here refer to the imported models
    return [
      LeaveRecord( // Constructor from leave_models.dart
        leaveType: 'Casual Leave',
        startDate: DateTime(2025, 6, 10),
        endDate: DateTime(2025, 6, 10),
        status: LeaveStatus.none, // Enum from leave_models.dart
        // reason: null, // Add properties if defined in model
        // additionalDates: null,
      ),
      LeaveRecord(
        leaveType: 'Annual Leave',
        startDate: DateTime(2025, 5, 23),
        endDate: DateTime(2025, 5, 28),
        // Use DateRange from leave_models.dart if applicable
        additionalDates: DateRange(DateTime(2025, 5, 29), DateTime(2025, 5, 29)),
        reason: "Vacation trip.",
        status: LeaveStatus.approved,
      ),
      LeaveRecord(
        leaveType: 'Sick Leave',
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 1),
        reason: "Flu symptoms",
        status: LeaveStatus.pending,
      ),
       LeaveRecord(
        leaveType: 'Vacation',
        startDate: DateTime(2025, 4, 22),
        endDate: DateTime(2025, 4, 26),
        reason: "Extended vacation",
        status: LeaveStatus.pending,
      ),
      LeaveRecord(
        leaveType: 'Casual Leave',
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 1),
        reason: "Personal appointment",
        status: LeaveStatus.rejected,
      ),
    ];
  }

} 