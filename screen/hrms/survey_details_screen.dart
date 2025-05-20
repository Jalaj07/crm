// screen/hrms/survey_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/screen/hrms/under_construction_page.dart'; // Adjust import

class SurveyDetailsScreen extends StatelessWidget {
  final String surveyId;
  final String surveyTitle;

  const SurveyDetailsScreen({
    super.key,
    required this.surveyId,
    required this.surveyTitle,
  });

  @override
  Widget build(BuildContext context) {
    // You can customize this page further later to show survey details
    // For now, it just uses the UnderConstructionPage
    return UnderConstructionPage(featureName: "Survey Details: $surveyTitle");
  }
}
