// models/survey_model.dart
import 'package:flutter/material.dart';
import 'survey_question_model.dart'; // Import the new question models

enum SurveyStatus {
  open,
  closed,
  pending,
  completed, // For individual completion status
}

extension SurveyStatusExtension on SurveyStatus {
  String get displayName {
    switch (this) {
      case SurveyStatus.open:
        return 'Open';
      case SurveyStatus.closed:
        return 'Closed';
      case SurveyStatus.pending:
        return 'Pending Review';
      case SurveyStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case SurveyStatus.open:
        return Colors.green.shade600;
      case SurveyStatus.closed:
        return Colors.red.shade600;
      case SurveyStatus.pending:
        return Colors.orange.shade600;
      case SurveyStatus.completed:
        return Colors.blue.shade600;
    }
  }

  IconData get icon {
    switch (this) {
      case SurveyStatus.open:
        return Icons.check_circle_outline;
      case SurveyStatus.closed:
        return Icons.cancel_outlined;
      case SurveyStatus.pending:
        return Icons.hourglass_empty_rounded;
      case SurveyStatus.completed:
        return Icons.task_alt_rounded;
    }
  }
}

enum SurveyDisplayMode {
  scrollablePage, // All questions on one scrollable page
  singleQuestionPerPage, // One (or more with same page number) question(s) at a time
}

class Survey {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final SurveyStatus status;
  final bool isCompletedByUser;
  final List<SurveyQuestion> questions; // Added: List of questions
  final SurveyDisplayMode
  displayMode; // Added: Display mode for the survey form

  Survey({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.status,
    this.isCompletedByUser = false,
    this.questions = const [], // Default to an empty list
    this.displayMode = SurveyDisplayMode.scrollablePage, // Default display mode
  });
}
