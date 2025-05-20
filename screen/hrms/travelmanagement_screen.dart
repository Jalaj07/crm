// lib/screens/travel_management_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../theme/central_app_theme_color.dart';

// Adjust paths based on your actual project structure
// VERIFY THESE PATHS CAREFULLY
import '../../data/dummy_travel_requests.dart';
import '../../constants/travelmanagement_filter_status.dart';
import '../../models/hrms/travelmanagement_travel_request.dart';

import '../../widgets/hrms/travelmanagement/travelmanagement_new_request_button.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_request_list_header.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_search_filter_bar.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_stats_overview_row.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_request_list.dart';
// Import the extracted widgets
import '../../widgets/hrms/travelmanagement/travelmanagement_request_form_sheet.dart';
import '../../widgets/hrms/travelmanagement/travelmanagement_request_details_dialog.dart';

// Optional: Import a logging package
// import 'package:logger/logger.dart';

class TravelManagementScreen extends StatefulWidget {
  const TravelManagementScreen({super.key});

  @override
  State<TravelManagementScreen> createState() => _TravelManagementScreenState();
}

class _TravelManagementScreenState extends State<TravelManagementScreen> {
  // --- State ---
  late List<TravelRequest> _allTravelRequests;

  // UI Interaction State
  String _selectedFilter = FilterStatus.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Utilities
  final DateFormat _dateFormatter = DateFormat(
    'MMM d, yyyy',
  ); // Consistent date format
  final Uuid _uuid = const Uuid(); // For generating unique IDs
  // final Logger _logger = Logger(); // Initialize logger if using a package

  // --- Lifecycle ---
  @override
  void initState() {
    super.initState();
    // Listen to search input changes
    _allTravelRequests = getDummyTravelRequests();
    _searchController.addListener(_onSearchChanged);
    // Initial sort (newest first)
    _allTravelRequests.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  void dispose() {
    // Clean up controllers and listeners
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // --- Getters (Derived State) ---

  // Calculate filtered list based on current filter and search query
  List<TravelRequest> get _filteredTravelRequests {
    final String lowerCaseQuery = _searchQuery.toLowerCase().trim();
    // Start with all requests, then apply filters sequentially
    Iterable<TravelRequest> filtered = _allTravelRequests;

    // Apply status filter (if not 'All')
    if (_selectedFilter != FilterStatus.all) {
      filtered = filtered.where((request) => request.status == _selectedFilter);
    }

    // Apply search query filter (if query exists)
    if (lowerCaseQuery.isNotEmpty) {
      filtered = filtered.where((request) {
        // Check multiple fields for the search term
        return request.requestId.toLowerCase().contains(lowerCaseQuery) ||
            request.name.toLowerCase().contains(lowerCaseQuery) ||
            request.travelType.toLowerCase().contains(lowerCaseQuery) ||
            request.travellerType.toLowerCase().contains(lowerCaseQuery) ||
            request.purpose.toLowerCase().contains(lowerCaseQuery) ||
            request.totalDays.toString().contains(
              lowerCaseQuery,
            ) || // Search number as string
            request.status.toLowerCase().contains(
              lowerCaseQuery,
            ); // Search status text
      });
    }
    // Sorting is handled on add/edit, no need to sort on every filter change here
    return filtered.toList();
  }

  // Calculate stats based on the *entire* list
  int get _totalRequestCount => _allTravelRequests.length;
  int get _pendingRequestCount =>
      _allTravelRequests
          .where((req) => req.status == FilterStatus.pending)
          .length;
  int get _approvedRequestCount =>
      _allTravelRequests
          .where((req) => req.status == FilterStatus.approved)
          .length;

  // --- Event Handlers ---

  // Update search query state when text field changes
  void _onSearchChanged() {
    final String newQuery = _searchController.text;
    if (_searchQuery != newQuery) {
      // Avoid unnecessary rebuilds if query didn't change
      setState(() {
        _searchQuery = newQuery;
      });
    }
  }

  // Update filter state when dropdown changes
  void _handleFilterChange(String? newValue) {
    if (newValue != null && newValue != _selectedFilter) {
      setState(() {
        _selectedFilter = newValue;
      });
    }
  }

  // Trigger opening the form for a new request
  void _handleNewRequestPressed() {
    _showFormSheet(); // No initial request passed
  }

  // Trigger opening the form to edit an existing request
  void _handleEditRequest(TravelRequest request) {
    _showFormSheet(requestToEdit: request); // Pass the request to edit
  }

  // Handle confirming and deleting a request
  void _handleDeleteRequest(TravelRequest requestToDelete) async {
    // Store context-dependent variables before async gap
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final StatusColors? statusTheme = theme.extension<StatusColors>();

    // Show confirmation dialog
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
          content: Text(
            'Are you sure you want to permanently delete request ${requestToDelete.requestId}?',
          ),
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

    // Check if component is still mounted and deletion was confirmed after await
    if (!mounted || confirmDelete != true) return;

    // Perform deletion
    setState(() {
      _allTravelRequests.removeWhere(
        (r) => r.requestId == requestToDelete.requestId,
      );
      // Log deletion: _logger.info('Deleted request ID: ${requestToDelete.requestId}');
    });

    // Show feedback
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Request ${requestToDelete.requestId} deleted.'),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Methods Interacting with Extracted Widgets ---

  // Show the modal bottom sheet using the extracted widget
  void _showFormSheet({TravelRequest? requestToEdit}) async {
    // Show the sheet and wait for the result (which is a Map)
    final Map<String, dynamic>? result =
        await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true, // Allows sheet to take more height
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          builder:
              (ctx) => TravelRequestFormSheet(
                initialRequest: requestToEdit,
              ), // Instantiate the external widget
        );

    // Check if mounted and if data was returned before proceeding
    if (!mounted || result == null) return;

    // Process the returned data
    _updateOrAddRequest(result, requestToEdit);
  }

  // Add or update a request based on form data
  void _updateOrAddRequest(
    Map<String, dynamic> formData,
    TravelRequest? originalRequest,
  ) {
    final bool isEditing = originalRequest != null;

    // Safely extract data from the map returned by the form sheet
    // Provide defaults in case keys are missing (though the form should ensure they exist)
    final String name = formData['name'] as String? ?? '';
    final String travelType = formData['travelType'] as String? ?? 'Unknown';
    final String travellerType =
        formData['travellerType'] as String? ?? 'Unknown';
    final int totalDays =
        formData['totalDays'] as int? ?? 1; // Already parsed in form
    final String purpose = formData['purpose'] as String? ?? '';
    final String status = formData['status'] as String? ?? FilterStatus.pending;
    final DateTime date = formData['date'] as DateTime? ?? DateTime.now();

    // Create the new/updated TravelRequest object using the model's constructor
    // Assumes your TravelRequest class has a constructor like this.
    // If it only has .fromMap, adapt this part accordingly.
    late TravelRequest changedRequest;
    if (isEditing) {
      changedRequest = TravelRequest(
        requestId: originalRequest.requestId, // Keep original ID for edits
        name: name,
        travelType: travelType,
        travellerType: travellerType,
        totalDays: totalDays,
        purpose: purpose,
        status: status,
        date: date,
      );
    } else {
      changedRequest = TravelRequest(
        requestId:
            'TR-${_uuid.v4().substring(0, 6).toUpperCase()}', // Generate new ID
        name: name,
        travelType: travelType,
        travellerType: travellerType,
        totalDays: totalDays,
        purpose: purpose,
        status: status, // New requests might default to pending
        date: date,
      );
    }

    // Update the state
    setState(() {
      if (isEditing) {
        // Find the index of the request being edited
        final int index = _allTravelRequests.indexWhere(
          (r) => r.requestId == changedRequest.requestId,
        );
        if (index != -1) {
          _allTravelRequests[index] = changedRequest; // Replace item at index
          // Log update: _logger.info('Updated request ID: ${changedRequest.requestId}');
        } else {
          // Handle error case where request to edit wasn't found (should not happen in normal flow)
          assert(
            false,
            'Error: Could not find request to update with ID: ${changedRequest.requestId}',
          );
          // _logger.warning('Attempted to update non-existent request: ${changedRequest.requestId}');
          return; // Prevent further state changes if error
        }
      } else {
        _allTravelRequests.insert(
          0,
          changedRequest,
        ); // Add new request to the beginning of the list
        // Log creation: _logger.info('Added new request ID: ${changedRequest.requestId}');
      }
      // Re-sort the list by date after any modification to maintain order
      _allTravelRequests.sort((a, b) => b.date.compareTo(a.date));
    });
    final theme = Theme.of(context); // Get theme
    final StatusColors? statusTheme = theme.extension<StatusColors>();
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Request updated!' : 'Request added!'),
        backgroundColor:
            isEditing
                ? statusTheme?.inProgress ??
                    Colors
                        .blue // e.g., InProgress for update
                : statusTheme?.approved ?? Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show the details dialog using the extracted widget
  void _handleViewDetails(TravelRequest request) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow closing by tapping outside
      builder: (BuildContext dialogContext) {
        // Instantiate the external dialog widget
        return TravelRequestDetailsDialog(
          request: request,
          dateFormatter:
              _dateFormatter, // Pass the formatter needed by the dialog
        );
      },
    );
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    // Calculate derived state needed for the build method
    final List<TravelRequest> filteredList = _filteredTravelRequests;
    final int totalCount = _totalRequestCount;
    final int pendingCount = _pendingRequestCount;
    final int approvedCount = _approvedRequestCount;

    return Scaffold(
      backgroundColor:
          Theme.of(
            context,
          ).colorScheme.surfaceContainerLowest, // Use theme color
      body: Column(
        // Main vertical layout
        children: [
          // Top Section: Search, Filter, Stats, New Request Button
          SearchFilterBar(
            searchController: _searchController, // Pass controller
            selectedFilter: _selectedFilter, // Pass current filter
            onFilterChanged:
                _handleFilterChange, // Pass callback for filter changes
          ),
          const SizedBox(height: 12),
          StatsOverviewRow(
            // Display overall stats
            totalCount: totalCount,
            pendingCount: pendingCount,
            approvedCount: approvedCount,
          ),
          const SizedBox(height: 12),
          NewRequestButton(
            onPressed: _handleNewRequestPressed,
          ), // Button to add new request
          const SizedBox(height: 16),

          // List Section: Header and the actual list
          RequestListHeader(
            filteredCount: filteredList.length, title: 'Travel Requests',
          ), // Show count of visible items
          const SizedBox(height: 8),
          Expanded(
            // Allow the list to take remaining vertical space and scroll
            child: TravelRequestList(
              requests: filteredList, // Pass the filtered list
              dateFormatter: _dateFormatter, // Pass formatter for list items
              // Pass callbacks for item interactions
              onTap: _handleViewDetails,
              onEdit: _handleEditRequest,
              onDelete: _handleDeleteRequest,
            ),
          ),
        ],
      ),
    );
  }
}
