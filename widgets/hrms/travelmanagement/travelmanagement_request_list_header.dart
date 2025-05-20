import 'package:flutter/material.dart';

class RequestListHeader extends StatelessWidget {
  final int filteredCount;
  final String title;

  const RequestListHeader({
    super.key,
    required this.filteredCount,
    this.title =
        'Travel Requests', // Default value if you want, or make it required
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            '$filteredCount Found', // Consistency in capitalization
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
