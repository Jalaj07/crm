// lib/screens/tour_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/models/ffm/sales_entry.dart';
//import 'package:flutter_development/widgets/ffm/tourplan/tour_plan_card.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs if needed for new plans

// Adjust paths for your project structure
import '../../constants/travelmanagement_filter_status.dart'; // Reusing FilterStatus
import '../../models/ffm/tour_plan.dart'; // Your new TourPlan model
import '../../theme/central_app_theme_color.dart'; // For StatusColors

// Reusable widgets from travelmanagement (if names are generic enough) or new tourplan widgets
import '../../widgets/hrms/travelmanagement/travelmanagement_request_list_header.dart'; // Can be made generic
import '../../widgets/hrms/travelmanagement/travelmanagement_search_filter_bar.dart'; // Reusable
import '../../widgets/hrms/travelmanagement/travelmanagement_stats_overview_row.dart'; // Reusable, just pass different data/labels

// TourPlan specific widgets
import '../../widgets/ffm/tourplan/tour_plan_form_sheet.dart';
import '../../widgets/ffm/tourplan/tour_plan_list.dart';
import '../../widgets/ffm/tourplan/tour_plan_details_dialog.dart';

// Optional: Import a logging package
// import 'package:logger/logger.dart';

// class TourPlanScreen extends StatefulWidget {
//   const TourPlanScreen({super.key});

//   @override
//   State<TourPlanScreen> createState() => _TourPlanScreenState();
// }

// class _TourPlanScreenState extends State<TourPlanScreen> {
//   // --- State ---
//   final List<TourPlan> _allTourPlans = [ // Example dummy data
//     TourPlan.fromMap({
//       'planId': 'TP24001',
//       'planName': 'Quarterly Client Visits - North',
//       'location': 'Delhi, Chandigarh',
//       'purposeOfVisit': 'Client Meeting',
//       'description': 'Meet key clients, discuss renewals and upsell opportunities.',
//       'travelMode': 'Car',
//       'fromDate': DateTime.now().add(const Duration(days: 7)),
//       'toDate': DateTime.now().add(const Duration(days: 10)),
//       // totalDays will be calculated by fromMap
//       'status': FilterStatus.pending,
//     }),
//     TourPlan.fromMap({
//       'planId': 'TP24002',
//       'planName': 'New Equipment Installation',
//       'location': 'Bangalore Site',
//       'purposeOfVisit': 'Installation',
//       'description': 'Install and configure new server racks for Project Phoenix.',
//       'travelMode': 'TAF (Travel Allowance Fixed)',
//       'fromDate': DateTime.now().add(const Duration(days: 2)),
//       'toDate': DateTime.now().add(const Duration(days: 4)),
//       'status': FilterStatus.approved,
//     }),
//   ];

//   String _selectedFilter = FilterStatus.all;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   final DateFormat _dateFormatter = DateFormat('MMM d, yyyy (EEE)');
//   final Uuid _uuid = const Uuid();
//   // final Logger _logger = Logger();

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _allTourPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate)); // Sort by fromDate
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   List<TourPlan> get _filteredTourPlans {
//     final String lowerCaseQuery = _searchQuery.toLowerCase().trim();
//     Iterable<TourPlan> filtered = _allTourPlans;

//     if (_selectedFilter != FilterStatus.all) {
//       filtered = filtered.where((plan) => plan.status == _selectedFilter);
//     }

//     if (lowerCaseQuery.isNotEmpty) {
//       filtered = filtered.where((plan) {
//         return plan.planId.toLowerCase().contains(lowerCaseQuery) ||
//             plan.planName.toLowerCase().contains(lowerCaseQuery) ||
//             plan.location.toLowerCase().contains(lowerCaseQuery) ||
//             plan.purposeOfVisit.toLowerCase().contains(lowerCaseQuery) ||
//             plan.description.toLowerCase().contains(lowerCaseQuery) ||
//             plan.travelMode.toLowerCase().contains(lowerCaseQuery) ||
//             plan.totalDays.toString().contains(lowerCaseQuery) ||
//             plan.status.toLowerCase().contains(lowerCaseQuery);
//       });
//     }
//     return filtered.toList();
//   }

//   int get _totalPlanCount => _allTourPlans.length;
//   int get _pendingPlanCount => _allTourPlans.where((p) => p.status == FilterStatus.pending).length;
//   int get _approvedPlanCount => _allTourPlans.where((p) => p.status == FilterStatus.approved).length;

//   void _onSearchChanged() {
//     if (_searchQuery != _searchController.text) {
//       setState(() { _searchQuery = _searchController.text; });
//     }
//   }

//   void _handleFilterChange(String? newValue) {
//     if (newValue != null && newValue != _selectedFilter) {
//       setState(() { _selectedFilter = newValue; });
//     }
//   }

//   void _handleNewTourPlanPressed() {
//     _showTourPlanFormSheet(); // No initial plan
//   }

//   void _handleEditTourPlan(TourPlan plan) {
//     _showTourPlanFormSheet(planToEdit: plan);
//   }

//   void _handleDeleteTourPlan(TourPlan planToDelete) async {
//     final scaffoldMessenger = ScaffoldMessenger.of(context);
//     final theme = Theme.of(context);
//     final statusTheme = theme.extension<StatusColors>();

//     final bool? confirmDelete = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: statusTheme?.pending ?? Colors.orange),
//               const SizedBox(width: 10),
//               const Text('Confirm Deletion'),
//             ],
//           ),
//           content: Text('Are you sure you want to permanently delete tour plan ${planToDelete.planId}?'),
//           actions: <Widget>[
//             TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
//             TextButton(
//               style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
//               onPressed: () => Navigator.of(dialogContext).pop(true),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );

//     if (!mounted || confirmDelete != true) return;

//     setState(() {
//       _allTourPlans.removeWhere((p) => p.planId == planToDelete.planId);
//       // _logger.info('Deleted plan ID: ${planToDelete.planId}');
//     });

//     scaffoldMessenger.showSnackBar(
//       SnackBar(
//         content: Text('Tour plan ${planToDelete.planId} deleted.'),
//         backgroundColor: theme.colorScheme.error,
//       ),
//     );
//   }

//   void _showTourPlanFormSheet({TourPlan? planToEdit}) async {
//     final Map<String, dynamic>? result = await showModalBottomSheet<Map<String, dynamic>>(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
//       builder: (ctx) => TourPlanFormSheet(initialPlan: planToEdit),
//     );

//     if (!mounted || result == null) return;
//     _updateOrAddTourPlan(result, planToEdit);
//   }

//   void _updateOrAddTourPlan(Map<String, dynamic> formData, TourPlan? originalPlan) {
//     final theme = Theme.of(context);
//     final statusTheme = theme.extension<StatusColors>();
//     final bool isEditing = originalPlan != null;

//     final String planId = formData['planId'] as String? ?? // if editing, use original, else generate new
//                            (isEditing ? originalPlan.planId : 'TP-${_uuid.v4().substring(0, 6).toUpperCase()}');

//     final TourPlan changedPlan = TourPlan(
//       planId: planId,
//       planName: formData['planName'] as String? ?? '',
//       location: formData['location'] as String? ?? '',
//       purposeOfVisit: formData['purposeOfVisit'] as String? ?? '',
//       description: formData['description'] as String? ?? '',
//       travelMode: formData['travelMode'] as String? ?? '',
//       fromDate: formData['fromDate'] as DateTime? ?? DateTime.now(),
//       toDate: formData['toDate'] as DateTime? ?? DateTime.now(),
//       totalDays: formData['totalDays'] as int? ?? 1,
//       status: formData['status'] as String? ?? FilterStatus.pending,
//     );

//     setState(() {
//       if (isEditing) {
//         final int index = _allTourPlans.indexWhere((p) => p.planId == changedPlan.planId);
//         if (index != -1) {
//           _allTourPlans[index] = changedPlan;
//           // _logger.info('Updated plan ID: ${changedPlan.planId}');
//         } else {
//           // _logger.warning('Attempted to update non-existent plan: ${changedPlan.planId}');
//           return;
//         }
//       } else {
//         _allTourPlans.insert(0, changedPlan);
//         // _logger.info('Added new plan ID: ${changedPlan.planId}');
//       }
//       _allTourPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(isEditing ? 'Tour Plan updated!' : 'Tour Plan added!'),
//         backgroundColor: isEditing ? statusTheme?.inProgress ?? Colors.blue : statusTheme?.approved ?? Colors.green,
//       ),
//     );
//   }

//   void _handleViewTourPlanDetails(TourPlan plan) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext dialogContext) {
//         return TourPlanDetailsDialog(initialPlan: plan, dateFormatter: _dateFormatter,
//           onPlanUpdated: _handlePlanUpdateFromDialog,);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<TourPlan> filteredList = _filteredTourPlans;
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surfaceContainerLowest,
//       body: Column(
//         children: [
//           SearchFilterBar(
//             searchController: _searchController,
//             selectedFilter: _selectedFilter,
//             onFilterChanged: _handleFilterChange,
//           ),
//           const SizedBox(height: 12),
//           StatsOverviewRow(
//             totalCount: _totalPlanCount,
//             pendingCount: _pendingPlanCount,
//             approvedCount: _approvedPlanCount,
//             // You might want to customize StatCard or StatsOverviewRow titles/icons
//           ),
//           const SizedBox(height: 12),
//           // Option 1: Reuse NewRequestButton and override its text via its properties if designed so.
//           // Option 2: Make NewRequestButton more generic or create a specific one.
//           // For simplicity, let's use a standard ElevatedButton here for now or ensure NewRequestButton is generic enough
//           Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 16.0),
//              child: ElevatedButton.icon(
//                 onPressed: _handleNewTourPlanPressed,
//                 icon: const Icon(Icons.add_location_alt_outlined),
//                 label: const Text('New Tour Plan'),
//                 style: ElevatedButton.styleFrom( // Or ensure this comes from theme
//                    minimumSize: const Size(double.infinity, 48),
//                   //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // from theme
//                   //  backgroundColor: theme.colorScheme.primary,
//                   //  foregroundColor: theme.colorScheme.onPrimary,
//                 ),
//             ),
//           ),
//           const SizedBox(height: 16),

//           RequestListHeader(
//             filteredCount: filteredList.length,
//             // title: 'Tour Plans', // Make title a parameter if needed
//           ), // If RequestListHeader is not generic, you'd change its text inside or make it so
//           const SizedBox(height: 8),
//           Expanded(
//             child: TourPlanList(
//               plans: filteredList,
//               dateFormatter: _dateFormatter,
//               onTap: _handleViewTourPlanDetails,
//               onEdit: _handleEditTourPlan,
//               onDelete: _handleDeleteTourPlan,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

const List<String> globalEmployeeNames = [
  'Alice Smith',
  'Bob Johnson',
  'Carol Williams',
  'Unassigned',
];

class TourPlanScreen extends StatefulWidget {
  const TourPlanScreen({super.key});

  @override
  State<TourPlanScreen> createState() => _TourPlanScreenState();
}

class _TourPlanScreenState extends State<TourPlanScreen> {
  final List<TourPlan> _allTourPlans = [
    // Example Dummy Data
    TourPlan.fromMap({
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
    TourPlan.fromMap({
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
    _allTourPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<TourPlan> get _filteredTourPlans {
    final String lowerCaseQuery = _searchQuery.toLowerCase().trim();
    Iterable<TourPlan> filtered = _allTourPlans;

    if (_selectedFilter != FilterStatus.all) {
      filtered = filtered.where((plan) => plan.status == _selectedFilter);
    }

    if (lowerCaseQuery.isNotEmpty) {
      filtered = filtered.where((plan) {
        return plan.planId.toLowerCase().contains(lowerCaseQuery) ||
            plan.planName.toLowerCase().contains(lowerCaseQuery) ||
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

  int get _totalPlanCount => _allTourPlans.length;
  int get _pendingPlanCount =>
      _allTourPlans.where((p) => p.status == FilterStatus.pending).length;
  int get _approvedPlanCount =>
      _allTourPlans.where((p) => p.status == FilterStatus.approved).length;
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

  void _handleNewTourPlanPressed() {
    _showTourPlanFormSheet();
  }

  void _handleEditTourPlan(TourPlan plan) {
    _showTourPlanFormSheet(planToEdit: plan);
  }

  void _handleDeleteTourPlan(TourPlan planToDelete) async {
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
          content: Text('Delete tour plan ${planToDelete.planId} permanently?'),
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
      () => _allTourPlans.removeWhere((p) => p.planId == planToDelete.planId),
    );
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Tour plan ${planToDelete.planId} deleted.'),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }

  void _showTourPlanFormSheet({TourPlan? planToEdit}) async {
    final Map<String, dynamic>? formData =
        await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => TourPlanFormSheet(initialPlan: planToEdit),
        );

    if (!mounted || formData == null) return;
    _updateOrAddTourPlan(formData, planToEdit);
  }

  void _updateOrAddTourPlan(
    Map<String, dynamic> formData,
    TourPlan? originalPlan,
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

    final TourPlan changedPlan = TourPlan(
      planId: planId,
      planName: formData['planName'] as String? ?? '',
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
        final int index = _allTourPlans.indexWhere(
          (p) => p.planId == changedPlan.planId,
        );
        if (index != -1) _allTourPlans[index] = changedPlan;
      } else {
        _allTourPlans.insert(0, changedPlan);
      }
      _allTourPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Tour Plan updated!' : 'Tour Plan added!'),
        backgroundColor:
            isEditing
                ? statusTheme?.inProgress ?? Colors.blue
                : statusTheme?.approved ?? Colors.green,
      ),
    );
  }

  void _handlePlanUpdateFromDialog(TourPlan updatedPlan) {
    setState(() {
      final index = _allTourPlans.indexWhere(
        (p) => p.planId == updatedPlan.planId,
      );
      if (index != -1) {
        _allTourPlans[index] = updatedPlan;
        // Optional: resort if fromDate or other sortable fields changed.
        _allTourPlans.sort((a, b) => b.fromDate.compareTo(a.fromDate));
      }
    });
  }

  void _handleViewTourPlanDetails(TourPlan plan) {
    showDialog(
      context: context,
      barrierDismissible: true, // Can be true
      builder: (BuildContext dialogContext) {
        return TourPlanDetailsDialog(
          plan: plan, // Pass the actual plan
          dateFormatter: _dateFormatter,
          onPlanUpdated: _handlePlanUpdateFromDialog,
          initialPlan: plan, // Pass the callback
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TourPlan> filteredList = _filteredTourPlans;
    final theme = Theme.of(context);

    // Calculate stats for "In Progress" if you want to display it
    int _ =
        _allTourPlans.where((p) => p.status == FilterStatus.inProgress).length;

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
              onPressed: _handleNewTourPlanPressed,
              icon: const Icon(Icons.group_add_outlined), // New Icon
              label: const Text('New Tour Plan'), // New Label
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // List Header (can be generic ListHeader)
          RequestListHeader(
            filteredCount: filteredList.length,
            title: 'Tour Plans',
            // title: 'Tour Plans', // Make title a parameter if needed
          ), // If RequestListHeader is not generic, you'd change its text inside or make it so
          const SizedBox(height: 8),
          Expanded(
            child: TourPlanList(
              plans: filteredList,
              dateFormatter: _dateFormatter,
              onTap: _handleViewTourPlanDetails,
              onEdit: _handleEditTourPlan,
              onDelete: _handleDeleteTourPlan,
            ),
          ),
        ],
      ),
    );
  }
}