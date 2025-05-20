import 'package:flutter/material.dart';

class FfmReassignScreen extends StatelessWidget {
  const FfmReassignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'FFM Reassign Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}