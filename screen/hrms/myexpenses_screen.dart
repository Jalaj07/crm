// lib/screen/hrms/myexpenses_screen.dart

// SECTION 1: IMPORTS
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Models and Constants
import '../../models/hrms/myexpenses/myexpenses.dart';
import '../../models/hrms/myexpenses/myexpenses_status.dart';
import '../../data/dummy_expenses.dart'; // Your extracted dummy data
import '../../theme/central_app_theme_color.dart'; // For StatusColors via ThemeController

// Reusable Widgets FROM TRAVEL MANAGEMENT (Ensure paths are correct to TM versions)
// You will create these under lib/widgets/common/ or lib/widgets/travelmanagement/ if they aren't there already
import '../../widgets/hrms/travelmanagement/travelmanagement_search_filter_bar.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_stats_overview_row.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_new_request_button.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_request_list_header.dart';

// Specific "Expense" versions of detailed TM widgets
// These you will CREATE by adapting the TM widgets for the Expense model
import '../../widgets/hrms/myexpenses/myexpense_item_card.dart'; // Adapt TravelRequestCard
import '../../widgets/hrms/myexpenses/myexpense_details_dialog.dart'; // Adapt TravelRequestDetailsDialog
import '../../widgets/hrms/myexpenses/myexpense_entry_form_sheet.dart'; // Adapt TravelRequestFormSheet

class MyExpensesScreen extends StatefulWidget {
  const MyExpensesScreen({super.key});

  @override
  State<MyExpensesScreen> createState() => _MyExpensesScreenState();
}

class _MyExpensesScreenState extends State<MyExpensesScreen> {
  // --- STATE ---
  final String _employeeName =
      "Rahul Sharma"; // Example, fetch from provider/auth
  late List<Expense> _allExpenses;
  List<Expense> _filteredExpenses = [];
  String _searchQuery = '';
  ExpenseStatus? _selectedFilterStatus; // Use your ExpenseStatus enum

  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat(
    'dd MMM, yyyy',
  ); // TM's date format example: 'MMM d, yyyy'
  final Uuid _uuid = const Uuid();

  // --- LIFECYCLE & DATA LOADING ---
  @override
  void initState() {
    super.initState();
    _allExpenses = getDummyExpenses(_employeeName);
    _allExpenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    _applyFilters();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // --- COMPUTED GETTERS for STATS ---
  Map<ExpenseStatus, int> get _statusCounts {
    final counts = <ExpenseStatus, int>{
      for (final s in ExpenseStatus.values) s: 0,
    };
    for (final ex in _allExpenses) {
      counts[ex.status] = (counts[ex.status] ?? 0) + 1;
    }
    return counts;
  }

  int get _totalCount => _allExpenses.length;
  int get _pendingCount =>
      _statusCounts[ExpenseStatus.submitted] ??
      0; // Mapping 'submitted' to 'pending' concept
  int get _approvedCount => _statusCounts[ExpenseStatus.approved] ?? 0;
  // Note: The TM StatsOverviewRow has 'Pending', 'Approved', and a 'Total'. If you need 'Paid' or 'Refused' there,
  // you'd need to modify StatsOverviewRow or use a different stats widget.

  // --- EVENT HANDLERS & FILTERING (Similar to Travel Management) ---
  void _onSearchChanged() {
    if (_searchQuery != _searchController.text) {
      setState(() => _searchQuery = _searchController.text);
      _applyFilters();
    }
  }

  // This will receive String from TM SearchFilterBar
  void _handleFilterChange(String? newValue) {
    setState(() {
      if (newValue == null || newValue == 'All') {
        _selectedFilterStatus = null;
      } else {
        // Convert string filter from TM bar back to ExpenseStatus
        _selectedFilterStatus = ExpenseStatus.values.firstWhere(
          (s) => s.displayName == newValue,
          orElse: () => ExpenseStatus.submitted, // A default fallback
        );
      }
      _applyFilters();
    });
  }

  void _applyFilters() {
    final String lowerCaseQuery = _searchQuery.toLowerCase().trim();
    _filteredExpenses =
        _allExpenses.where((expense) {
          final statusMatch =
              (_selectedFilterStatus == null ||
                  expense.status == _selectedFilterStatus);
          if (!statusMatch) return false;

          if (lowerCaseQuery.isEmpty) return true;
          return expense.id.toLowerCase().contains(lowerCaseQuery) ||
              expense.description.toLowerCase().contains(lowerCaseQuery) ||
              expense.expenseType.toLowerCase().contains(lowerCaseQuery) ||
              expense.amount.toString().contains(lowerCaseQuery) ||
              expense.status.displayName.toLowerCase().contains(
                lowerCaseQuery,
              ) ||
              _dateFormatter
                  .format(expense.expenseDate)
                  .toLowerCase()
                  .contains(lowerCaseQuery);
        }).toList();
    // Call setState here if _applyFilters modifies a list that directly drives UI
    // and is not within a getter used by build(). Since _filteredExpenses is used,
    // if _applyFilters is called outside of a context where setState will naturally be
    // called afterwards (like _onSearchChanged which has its own setState), then call it here.
    // For safety, if _applyFilters is called from multiple places without direct setStates:
    if (mounted) setState(() {});
  }

  // --- CRUD OPERATIONS ---
  void _addOrUpdateExpense(
    Map<String, dynamic> formData,
    Expense? originalExpense,
  ) {
    final bool isEditing = originalExpense != null;
    final String expenseId =
        isEditing
            ? originalExpense.id
            : 'EXP-${_uuid.v4().substring(0, 6).toUpperCase()}';

    final Expense changedExpense = Expense(
      id: expenseId,
      expenseDate: formData['expenseDate'] as DateTime,
      description: formData['description'] as String,
      amount: formData['amount'] as double,
      expenseType: formData['expenseType'] as String,
      status:
          isEditing
              ? originalExpense.status
              : ExpenseStatus.submitted, // Preserve status on edit, new default
      employeeName: _employeeName, // Or from formData if applicable
      visit: formData['visit'] as String? ?? 'N/A',
      visitSchedule: formData['visitSchedule'] as String? ?? 'N/A',
      distanceCovered: formData['distanceCovered'] as double? ?? 0.0,
    );

    setState(() {
      if (isEditing) {
        final index = _allExpenses.indexWhere((e) => e.id == changedExpense.id);
        if (index != -1) _allExpenses[index] = changedExpense;
      } else {
        _allExpenses.insert(0, changedExpense);
      }
      _allExpenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
      _applyFilters();
    });

    final statusColors =
        Theme.of(
          context,
        ).extension<StatusColors>(); // Get status colors instance
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Expense updated!' : 'Expense added!'),
        backgroundColor:
            isEditing
                ? (statusColors?.pending ??
                    Colors.orange) // Color for "updated"
                : (statusColors?.approved ?? Colors.green), // Color for "added"
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDeleteExpense(Expense expenseToDelete) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Theme.of(context);

    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(dialogContext).colorScheme.error,
                ),
                const SizedBox(width: 10),
                const Text('Confirm Delete'),
              ],
            ),
            content: Text(
              'Are you sure you want to delete expense "${expenseToDelete.description}"? This action cannot be undone.',
            ), // Added detail
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(dialogContext).colorScheme.error,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (!mounted || confirmDelete != true) return;
    setState(() {
      _allExpenses.removeWhere((e) => e.id == expenseToDelete.id);
      _applyFilters();
    });
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          // Apply style directly to the Text widget
          'Expense "${expenseToDelete.description}" has been deleted.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ), // Corrected way to style
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- SHOWING FORMS/DIALOGS (USING ADAPTED TM WIDGETS) ---
  void _showExpenseEntryFormSheet({Expense? expenseToEdit}) async {
    final Map<String, dynamic>?
    result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder:
          (ctx) => ExpenseEntryFormSheet(
            // This is your NEWLY ADAPTED widget
            initialExpense: expenseToEdit,
            // You might pass field definitions or specific parameters needed by this form
            // that differ from the simple TravelRequestFormSheet
          ),
    );
    if (!mounted || result == null) return;
    _addOrUpdateExpense(result, expenseToEdit);
  }

  void _showExpenseDetailsDialog(Expense expense) {
    showDialog(
      context: context,
      builder:
          (ctx) => ExpenseDetailsDialog(
            // This is your NEWLY ADAPTED widget
            expense: expense,
            dateFormatter: _dateFormatter,
            // TM's TravelRequestDetailsDialog might not have edit/delete actions directly inside it
            // If ExpenseDetailsDialog is a direct adaptation, it will reflect that.
            // You can add onEdit/onDelete parameters if this dialog supports actions.
          ),
    );
  }

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Assuming not null for TM widgets

    // Generate filter items for TM's SearchFilterBar
    // It expects List<String>. Your ExpenseStatus.displayName can provide this.
    final List<String> filterOptions =
        ExpenseStatus.values.map((s) => s.displayName).toList();
    filterOptions.insert(0, 'All'); // Add "All" option

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          // Reusing Travel Management SearchFilterBar
          SearchFilterBar(
            searchController: _searchController,
            selectedFilter: _selectedFilterStatus?.displayName ?? 'All',
            onFilterChanged: _handleFilterChange,
            // filterItems: filterOptions, // Assuming TM SearchFilterBar takes filterItems for dropdown
            // This part is crucial and might need SearchFilterBar modification
            // If it uses hardcoded FilterStatus.values (TM version),
            // we need to ensure string values match
          ),
          const SizedBox(height: 12),

          // Reusing Travel Management StatsOverviewRow
          StatsOverviewRow(
            totalCount: _totalCount,
            pendingCount: _pendingCount, // Maps to ExpenseStatus.submitted
            approvedCount: _approvedCount,
            // Ensure colors/icons used by StatCard inside StatsOverviewRow
            // map correctly through StatusColors extension
          ),
          const SizedBox(height: 12),

          // Reusing Travel Management NewRequestButton
          NewRequestButton(
            onPressed: () => _showExpenseEntryFormSheet(),
            label: 'New Expense Request',
            icon: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 16),

          // Reusing Travel Management RequestListHeader
          RequestListHeader(
            title: 'My Expenses', // Customize title
            filteredCount: _filteredExpenses.length,
          ),
          const SizedBox(height: 8),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _allExpenses = getDummyExpenses(_employeeName);
                _applyFilters();
                setState(() {});
              }, // Simplified refresh
              child:
                  _filteredExpenses.isEmpty
                      ? Center(
                        child: Text(
                          _searchQuery.isNotEmpty ||
                                  _selectedFilterStatus != null
                              ? 'No expenses match criteria.'
                              : 'No expenses yet.',
                          style: theme.textTheme.titleMedium,
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding,
                          0,
                          kDefaultPadding,
                          kDefaultPadding,
                        ), // Assuming kDefaultPadding
                        itemCount: _filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = _filteredExpenses[index];
                          // Using the new ExpenseItemCard (adapted from TravelRequestCard)
                          return ExpenseItemCard(
                            expense: expense,
                            dateFormatter: _dateFormatter,
                            onTap: () => _showExpenseDetailsDialog(expense),
                            onEdit:
                                () => _showExpenseEntryFormSheet(
                                  expenseToEdit: expense,
                                ),
                            onDelete: () => _handleDeleteExpense(expense),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for padding if not defined elsewhere (original TM might have had this)
const double kDefaultPadding = 16.0;
