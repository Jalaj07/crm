import 'package:flutter/material.dart';
import 'package:flutter_development/models/hrms/travelmanagement_travel_request.dart'; // Adjust path
import 'package:flutter_development/widgets/hrms/travelmanagement/travelmanagement_request_card.dart'; // Adjust path
import 'package:intl/intl.dart'; // Needed for DateFormat parameter

class TravelRequestList extends StatelessWidget {
  final List<TravelRequest> requests;
  final DateFormat dateFormatter; // Required parameter
  final Function(TravelRequest) onTap; // Callback for view details action
  final Function(TravelRequest) onEdit; // Callback for edit action
  final Function(TravelRequest) onDelete; // Callback for delete action

  const TravelRequestList({
    super.key,
    required this.requests,
    required this.dateFormatter, // Required parameter
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No travel requests found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ), // Use themed color
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filter.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ), // Use themed color
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          16,
        ), // Add overall list padding
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          // Pass dateFormatter down to TravelRequestCard
          return TravelRequestCard(
            request: request,
            dateFormatter: dateFormatter,
            onTap: onTap,
            onEdit: onEdit,
            onDelete: onDelete,
          );
        },
      ),
    );
  }
}
