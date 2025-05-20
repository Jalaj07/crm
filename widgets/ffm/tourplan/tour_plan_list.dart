// lib/widgets/tourplan/tour_plan_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/tour_plan.dart'; // Path to your TourPlan model
import 'tour_plan_card.dart'; // Path to your TourPlanCard

class TourPlanList extends StatelessWidget {
  final List<TourPlan> plans;
  final DateFormat dateFormatter;
  final Function(TourPlan) onTap;
  final Function(TourPlan) onEdit;
  final Function(TourPlan) onDelete;

  const TourPlanList({
    super.key,
    required this.plans,
    required this.dateFormatter,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return Center( // Removed Expanded as parent usually handles it
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 64, color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            Text(
              'No tour plans found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter, or create a new plan.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return TourPlanCard(
          plan: plan,
          dateFormatter: dateFormatter,
          onTap: onTap,
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}