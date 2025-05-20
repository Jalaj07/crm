import 'package:flutter/material.dart';

class UnderConstructionPage extends StatelessWidget {
  final String featureName;
  const UnderConstructionPage({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              '$featureName is under construction.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'We are working hard to bring this feature to you soon!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
