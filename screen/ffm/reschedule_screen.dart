import 'package:flutter/material.dart';

class FfmRescheduleScreen extends StatelessWidget {
  const FfmRescheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Reschedule Tasks")), // Usually AppBar is handled by MainNavigationScreen
      body: Center(
        child: Text(
          'FFM Reschedule Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}