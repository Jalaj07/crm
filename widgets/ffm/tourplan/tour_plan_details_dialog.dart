// lib/widgets/tourplan/tour_plan_details_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/tour_plan.dart'; // Your TourPlan model
import '../../../models/ffm/sales_entry.dart'; // Import the SalesEntry model
import '../../../constants/travelmanagement_filter_status.dart'; // Reusing
import '../../../theme/central_app_theme_color.dart'; // For StatusColors
import '../myteamplan/sales_entry_card.dart';
import '../myteamplan/sales_entry_form_sheet.dart';

class TourPlanDetailsDialog extends StatefulWidget {
  final TourPlan initialPlan;
  final DateFormat dateFormatter;
  final Function(TourPlan)
  onPlanUpdated; // Callback to update plan in the main screen's state

  const TourPlanDetailsDialog({
    required this.initialPlan,
    required this.dateFormatter,
    required this.onPlanUpdated,
    super.key,
    required TourPlan plan,
  });

  @override
  State<TourPlanDetailsDialog> createState() => _TourPlanDetailsDialogState();
}

class _TourPlanDetailsDialogState extends State<TourPlanDetailsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TourPlan _currentPlan;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentPlan =
        widget
            .initialPlan; // Make a mutable copy or work with a copy from parent
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper for Plan Details Tab
  Widget _buildDetailRow(
    BuildContext context, {
    IconData? icon,
    required String label,
    required String value,
  }) {
    // ... (Same as in TourPlanDetailsDialog or TeamPlanCard's _buildVerticalDetail)
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child:
                icon != null
                    ? Icon(icon, size: 18, color: theme.colorScheme.primary)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  TextSpan(
                    text: value.isNotEmpty ? value : '-',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addOrEditSalesEntry({SalesEntry? existingEntry}) async {
    final result = await showModalBottomSheet<SalesEntry>(
      // Expect SalesEntry object back
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (ctx) => SalesEntryFormSheet(initialSalesEntry: existingEntry),
    );

    if (result != null) {
      setState(() {
        if (existingEntry == null) {
          // Adding new
          _currentPlan.salesEntries.insert(0, result); // Add to beginning
        } else {
          // Editing existing
          final index = _currentPlan.salesEntries.indexWhere(
            (e) => e.entryId == existingEntry.entryId,
          );
          if (index != -1) {
            _currentPlan.salesEntries[index] = result;
          }
        }
        widget.onPlanUpdated(
          _currentPlan.copyWith(
            salesEntries: List.from(_currentPlan.salesEntries),
          ),
        ); // Notify parent
      });
    }
  }

  void _deleteSalesEntry(SalesEntry entryToDelete) async {
    // Confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Delete sales entry "${entryToDelete.salesNumber}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        _currentPlan.salesEntries.removeWhere(
          (e) => e.entryId == entryToDelete.entryId,
        );
        widget.onPlanUpdated(
          _currentPlan.copyWith(
            salesEntries: List.from(_currentPlan.salesEntries),
          ),
        ); // Notify parent
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sales entry deleted.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StatusColors? statusTheme = theme.extension<StatusColors>();
    if (statusTheme == null) {
      return const AlertDialog(content: Text("Theme error"));
    }

    final Color planStatusColor = FilterStatus.getColor(
      _currentPlan.status,
      statusTheme,
    );
    final Color planStatusBgColor = FilterStatus.getBackgroundColor(
      _currentPlan.status,
      statusTheme,
    );

    // Ensure AlertDialog can accommodate TabBar and TabBarView height
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ), // Adjust to allow more height
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: EdgeInsets.zero, // We will manage padding in tabs
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(Icons.wysiwyg_outlined, size: 24),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Tour Plan Details',
                        style: theme.textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: planStatusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _currentPlan.status,
                  style: TextStyle(
                    color: planStatusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [Tab(text: 'Details'), Tab(text: 'Sales Entries')],
          ),
        ],
      ),
      content: SizedBox(
        // Constrain height of the content area
        width: MediaQuery.of(context).size.width * 0.9, // Max width
        height:
            MediaQuery.of(context).size.height * 0.6, // Max height for content
        child: TabBarView(
          controller: _tabController,
          children: [
            // --- Details Tab ---
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: ListBody(
                children: <Widget>[
                  _buildDetailRow(
                    context,
                    icon: Icons.vpn_key_outlined,
                    label: 'Plan ID',
                    value: _currentPlan.planId,
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.label_outline,
                    label: 'Plan Name',
                    value: _currentPlan.planName,
                  ),

                  _buildDetailRow(
                    context,
                    icon: Icons.location_city_outlined,
                    label: 'Location',
                    value: _currentPlan.location,
                  ),
                  const Divider(height: 15, indent: 36),
                  _buildDetailRow(
                    context,
                    icon: Icons.flag_outlined,
                    label: 'Purpose of Visit',
                    value: _currentPlan.purposeOfVisit,
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.notes_outlined,
                    label: 'Description',
                    value: _currentPlan.description,
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.commute_outlined,
                    label: 'Travel Mode',
                    value: _currentPlan.travelMode,
                  ),
                  const Divider(height: 15, indent: 36),
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_view_day_outlined,
                    label: 'From Date',
                    value: widget.dateFormatter.format(_currentPlan.fromDate),
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_view_week_outlined,
                    label: 'To Date',
                    value: widget.dateFormatter.format(_currentPlan.toDate),
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.hourglass_bottom_outlined,
                    label: 'Total Days',
                    value:
                        '${_currentPlan.totalDays} Day${_currentPlan.totalDays != 1 ? 's' : ''}',
                  ),
                ],
              ),
            ),

            // --- Sales Tab ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ), // Reduced padding for list area
              child: Column(
                children: [
                  Expanded(
                    child:
                        _currentPlan.salesEntries.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.point_of_sale_outlined,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('No sales entries yet.'),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    label: const Text('Add First Entry'),
                                    onPressed: () => _addOrEditSalesEntry(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.secondary,
                                      foregroundColor:
                                          theme.colorScheme.onSecondary,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: _currentPlan.salesEntries.length,
                              itemBuilder: (context, index) {
                                final entry = _currentPlan.salesEntries[index];
                                return SalesEntryCard(
                                  salesEntry: entry,
                                  dateFormatter: widget.dateFormatter,
                                  onEdit:
                                      () => _addOrEditSalesEntry(
                                        existingEntry: entry,
                                      ),
                                  onDelete: () => _deleteSalesEntry(entry),
                                );
                              },
                            ),
                  ),
                  if (_currentPlan
                      .salesEntries
                      .isNotEmpty) // Show add button at bottom if list is not empty
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add Sales Entry'),
                        onPressed: () => _addOrEditSalesEntry(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: theme.colorScheme.onSecondary,
                          minimumSize: const Size(double.infinity, 40),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
