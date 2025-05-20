// lib/screens/my_team_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../constants/travelmanagement_filter_status.dart';
import '../../models/ffm/my_team_plan.dart';
import '../../models/ffm/sales_entry.dart'; // For dummy data if needed
import '../../theme/central_app_theme_color.dart'; // For StatusColors

// Reusable generic widgets
import '../../widgets/hrms/travelmanagement/travelmanagement_search_filter_bar.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_stats_overview_row.dart';

// MyTeamPlan specific widgets
import '../../widgets/ffm/myteamplan/my_team_plan_form_sheet.dart';
import '../../widgets/ffm/myteamplan/my_team_plan_card.dart'; // Updated Card name
import '../../widgets/ffm/myteamplan/my_team_plan_details_dialog.dart'; // Updated Dialog name

// Example employee names (move to constants or fetch)
const List<String> globalEmployeeNames = [
  'Alice Smith',
  'Bob Johnson',
  'Carol Williams',
  'Unassigned',
];

class MyTeamPlanScreen extends StatefulWidget {
  const MyTeamPlanScreen({super.key});

  @override
  State<MyTeamPlanScreen> createState() => _MyTeamPlanScreenState();
}

class _MyTeamPlanScreenState extends State<MyTeamPlanScreen> {
  final List<MyTeamPlan> _allMyTeamPlans = [
    // Example Dummy Data
    MyTeamPlan.fromMap({
      'planId': 'MTP24001',
      'planName': 'Q3 Sales Drive - West Zone',
      'assignedTo': globalEmployeeNames[0], // Alice
      'location': 'Mumbai, Pune',
      'purposeOfVisit': 'Sales Visit',
      'description':
          'Target new leads and close existing pipeline deals in West Zone.',
      'travelMode': 'Car',
      'fromDate': DateTime.now().add(const Duration(days: 5)),
      'toDate': DateTime.now().add(const Duration(days: 12)),
      'status': FilterStatus.inProgress,
      'salesEntries': [
        SalesEntry.fromMap({
          'entryId': 'SE001',
          'salesNumber': 'SN-WZ-001',
          'customerName': 'Alpha Corp',
          'customerAddress': 'Andheri, Mumbai',
          'date': DateTime.now().add(const Duration(days: 6)),
          'status': SalesStatus.inProgress,
          'amount': 50000.0,
        }).toMap(),
        SalesEntry.fromMap({
          'entryId': 'SE002',
          'salesNumber': 'SN-WZ-002',
          'customerName': 'Beta Solutions',
          'customerAddress': 'Baner, Pune',
          'date': DateTime.now().add(const Duration(days: 8)),
          'status': SalesStatus.approved,
          'amount': 120000.0,
        }).toMap(),
      ],
    }),
    MyTeamPlan.fromMap({
      'planId': 'MTP24002',
      'planName': 'Key Account Management - North',
      'assignedTo': globalEmployeeNames[1], // Bob
      'location': 'Delhi, Gurugram',
      'purposeOfVisit': 'Client Meeting',
      'description': 'Relationship building with top 5 accounts.',
      'travelMode': 'TAF (Travel Allowance Fixed)',
      'fromDate': DateTime.now().add(const Duration(days: 15)),
      'toDate': DateTime.now().add(const Duration(days: 18)),
      'status': FilterStatus.pending,
      'salesEntries': [], // No sales entries yet
    }),
  ];

  String _selectedFilter = FilterStatus.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final DateFormat _dateFormatter = DateFormat('MMM d, yyyy');
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _allMyTeamPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<MyTeamPlan> get _filteredMyTeamPlans {
    final String lowerCaseQuery = _searchQuery.toLowerCase().trim();
    Iterable<MyTeamPlan> filtered = _allMyTeamPlans;

    if (_selectedFilter != FilterStatus.all) {
      filtered = filtered.where((plan) => plan.status == _selectedFilter);
    }

    if (lowerCaseQuery.isNotEmpty) {
      filtered = filtered.where((plan) {
        return plan.planId.toLowerCase().contains(lowerCaseQuery) ||
            plan.planName.toLowerCase().contains(lowerCaseQuery) ||
            (plan.assignedTo?.toLowerCase().contains(lowerCaseQuery) ??
                false) ||
            plan.location.toLowerCase().contains(lowerCaseQuery) ||
            plan.purposeOfVisit.toLowerCase().contains(lowerCaseQuery) ||
            plan.description.toLowerCase().contains(lowerCaseQuery) ||
            plan.travelMode.toLowerCase().contains(lowerCaseQuery) ||
            plan.totalDays.toString().contains(lowerCaseQuery) ||
            plan.status.toLowerCase().contains(lowerCaseQuery);
      });
    }
    return filtered.toList();
  }

  int get _totalPlanCount => _allMyTeamPlans.length;
  int get _pendingPlanCount =>
      _allMyTeamPlans.where((p) => p.status == FilterStatus.pending).length;
  int get _approvedPlanCount =>
      _allMyTeamPlans.where((p) => p.status == FilterStatus.approved).length;
  // You might add other counts (e.g., In Progress)

  void _onSearchChanged() {
    /* ... same as before ... */
    if (_searchQuery != _searchController.text) {
      setState(() {
        _searchQuery = _searchController.text;
      });
    }
  }

  void _handleFilterChange(String? newValue) {
    /* ... same as before ... */
    if (newValue != null && newValue != _selectedFilter) {
      setState(() {
        _selectedFilter = newValue;
      });
    }
  }

  void _handleNewTeamPlanPressed() {
    _showMyTeamPlanFormSheet();
  }

  void _handleEditTeamPlan(MyTeamPlan plan) {
    _showMyTeamPlanFormSheet(planToEdit: plan);
  }

  void _handleDeleteTeamPlan(MyTeamPlan planToDelete) async {
    /* ... same as before, just wording ... */
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final statusTheme = theme.extension<StatusColors>();

    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: statusTheme?.pending ?? Colors.orange,
              ),
              const SizedBox(width: 10),
              const Text('Confirm Deletion'),
            ],
          ),
          content: Text('Delete team plan ${planToDelete.planId} permanently?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (!mounted || confirmDelete != true) return;
    setState(
      () => _allMyTeamPlans.removeWhere((p) => p.planId == planToDelete.planId),
    );
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Team plan ${planToDelete.planId} deleted.'),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }

  void _showMyTeamPlanFormSheet({MyTeamPlan? planToEdit}) async {
    final Map<String, dynamic>? formData =
        await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => MyTeamPlanFormSheet(initialPlan: planToEdit),
        );

    if (!mounted || formData == null) return;
    _updateOrAddMyTeamPlan(formData, planToEdit);
  }

  void _updateOrAddMyTeamPlan(
    Map<String, dynamic> formData,
    MyTeamPlan? originalPlan,
  ) {
    final theme = Theme.of(context);
    final statusTheme = theme.extension<StatusColors>();
    final bool isEditing = originalPlan != null;

    final String planId =
        formData['planId'] as String? ??
        (isEditing
            ? originalPlan.planId
            : 'MTP-${_uuid.v4().substring(0, 5).toUpperCase()}');

    // When creating a new plan, salesEntries will be empty.
    // When editing, we preserve existing sales entries unless form explicitly modifies them (which it doesn't directly).
    // Sales entries are managed through the details dialog.
    List<SalesEntry> salesEntries = isEditing ? originalPlan.salesEntries : [];

    final MyTeamPlan changedPlan = MyTeamPlan(
      planId: planId,
      planName: formData['planName'] as String? ?? '',
      assignedTo:
          formData['assignedTo']
              as String?, // Already handled 'Unassigned' in form
      location: formData['location'] as String? ?? '',
      purposeOfVisit: formData['purposeOfVisit'] as String? ?? '',
      description: formData['description'] as String? ?? '',
      travelMode: formData['travelMode'] as String? ?? '',
      fromDate: formData['fromDate'] as DateTime? ?? DateTime.now(),
      toDate: formData['toDate'] as DateTime? ?? DateTime.now(),
      totalDays: formData['totalDays'] as int? ?? 1,
      status: formData['status'] as String? ?? FilterStatus.pending,
      salesEntries: salesEntries, // Preserve existing sales entries
    );

    setState(() {
      if (isEditing) {
        final int index = _allMyTeamPlans.indexWhere(
          (p) => p.planId == changedPlan.planId,
        );
        if (index != -1) _allMyTeamPlans[index] = changedPlan;
      } else {
        _allMyTeamPlans.insert(0, changedPlan);
      }
      _allMyTeamPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Team Plan updated!' : 'Team Plan added!'),
        backgroundColor:
            isEditing
                ? statusTheme?.inProgress ?? Colors.blue
                : statusTheme?.approved ?? Colors.green,
      ),
    );
  }

  void _handlePlanUpdateFromDialog(MyTeamPlan updatedPlan) {
    setState(() {
      final index = _allMyTeamPlans.indexWhere(
        (p) => p.planId == updatedPlan.planId,
      );
      if (index != -1) {
        _allMyTeamPlans[index] = updatedPlan;
        // Optional: resort if fromDate or other sortable fields changed.
        _allMyTeamPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
      }
    });
  }

  void _handleViewTeamPlanDetails(MyTeamPlan plan) {
    showDialog(
      context: context,
      barrierDismissible: true, // Can be true
      builder: (BuildContext dialogContext) {
        return MyTeamPlanDetailsDialog(
          initialPlan: plan, // Pass the actual plan
          dateFormatter: _dateFormatter,
          onPlanUpdated: _handlePlanUpdateFromDialog, // Pass the callback
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<MyTeamPlan> filteredList = _filteredMyTeamPlans;
    final theme = Theme.of(context);

    // Calculate stats for "In Progress" if you want to display it
    int _ =
        _allMyTeamPlans
            .where((p) => p.status == FilterStatus.inProgress)
            .length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          SearchFilterBar(
            // Reusable
            searchController: _searchController,
            selectedFilter: _selectedFilter,
            onFilterChanged: _handleFilterChange,
            // Optional: customize hintText
            // hintText: 'Search My Team Plans...',
          ),
          const SizedBox(height: 12),
          // StatsOverviewRow is reusable, pass relevant counts and labels
          StatsOverviewRow(
            totalCount: _totalPlanCount,
            pendingCount: _pendingPlanCount,
            approvedCount: _approvedPlanCount,
            // You could add another StatCard for "In Progress" or make StatsOverviewRow more flexible
            // Example: For a third stat (if StatsOverviewRow is modified to accept a list of StatCardData)
            //  statData: [
            //    StatCardData(title: 'Total', value: _totalPlanCount.toString(), icon: Icons.all_inbox, color: theme.colorScheme.primary),
            //    StatCardData(title: FilterStatus.pending, value: _pendingPlanCount.toString(), icon: Icons.pending, color: theme.colorScheme.tertiary),
            //    StatCardData(title: FilterStatus.approved, value: _approvedPlanCount.toString(), icon: Icons.check_circle, color: theme.colorScheme.secondary),
            //  ]
          ),
          const SizedBox(height: 12),
          // New Button (can be generic NewEntityButton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _handleNewTeamPlanPressed,
              icon: const Icon(Icons.group_add_outlined), // New Icon
              label: const Text('New Team Plan'), // New Label
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // List Header (can be generic ListHeader)
          Padding(
            // Recreating generic header for now
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Team Plans',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${filteredList.length} Found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                filteredList.isEmpty
                    ? Center(
                      // Empty state
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No team plans found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      // The List for MyTeamPlanCard
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final plan = filteredList[index];
                        return MyTeamPlanCard(
                          // Using the new card
                          plan: plan,
                          dateFormatter: _dateFormatter,
                          onTap: _handleViewTeamPlanDetails,
                          onEdit: _handleEditTeamPlan,
                          onDelete: _handleDeleteTeamPlan,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
