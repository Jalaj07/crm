import 'package:flutter/material.dart';
import 'package:flutter_development/constants/myideas_constants.dart';

// Made public by removing leading underscore
class EmptyIdeasView extends StatelessWidget {
  const EmptyIdeasView({super.key}); // Added key

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.screenPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: AppConstants.sectionSpacing),
            Text(
              'No ideas yet!',
              style: textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.itemSpacing),
            Text(
              'Select "New Idea" above to share your first brilliant idea.',
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
