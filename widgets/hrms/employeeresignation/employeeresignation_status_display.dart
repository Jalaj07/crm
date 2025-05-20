// lib/features/resignation/presentation/widgets/status_display.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/constants/employeeresignation_constants.dart';

class StatusDisplay extends StatelessWidget {
  final String status;

  const StatusDisplay({super.key, required this.status});

  bool get _isDraft => status == ResignationConstants.statusDraft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: 'Status: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            TextSpan(
              text: status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isDraft ? Colors.orangeAccent : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
