// lib/features/resignation/presentation/widgets/form_section_header.dart
import 'package:flutter/material.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;

  const FormSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(height: 20, thickness: 1),
        // Spacing after header is handled by SizedBox in the main layout
      ],
    );
  }
}
