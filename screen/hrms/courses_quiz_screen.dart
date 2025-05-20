// lib/pages/quiz_page.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/hrms/courses/courses_quiz.dart';
import '../../widgets/hrms/courses/courses_quiz_card.dart';
import '../../constants/courses_layout_constants.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    // No context use before await, so initial mounted check is fine here
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // --- Dummy Data ---
      final mockQuizData = [
        {
          'id': 'q1',
          'title': 'Leadership Fundamentals Quiz',
          'description':
              'Test your understanding of core leadership principles covered in the course.',
          'numberOfQuestions': 10,
          'estimatedTime': '15 min',
        },
        {
          'id': 'q2',
          'title': 'Engineering Basics Assessment',
          'description':
              'Check your knowledge of fundamental engineering concepts.',
          'numberOfQuestions': 20,
          'estimatedTime': '30 min',
        },
        {
          'id': 'q3',
          'title': 'Communication Skills Check-up',
          'description':
              'A quick quiz on effective workplace communication and email etiquette.',
          'numberOfQuestions': 8,
          'estimatedTime': '10 min',
        },
        {
          'id': 'q4',
          'title': 'Flutter Performance Quiz',
          'description':
              'Challenge yourself on advanced Flutter topics related to app performance.',
          'numberOfQuestions': 15,
          'estimatedTime': '25 min',
        },
      ];

      // Simulate potential failure
      // if (DateTime.now().second % 3 == 0) {
      //   throw Exception("Failed to load quizzes.");
      // }

      // IMPORTANT: Check mounted *again* before setState after await
      if (!mounted) return;

      setState(() {
        _quizzes = mockQuizData.map((data) => Quiz.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      // IMPORTANT: Check mounted before setState after await (implicitly in catch)
      if (!mounted) return;
      setState(() {
        _error = "Error loading quizzes: ${e.toString()}. Please try again.";
        _isLoading = false;
      });
    }
  }

  void _handleSelectQuiz(Quiz quiz) {
    showModalBottomSheet(
      context: context, // Context usage before await is fine
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (modalContext) => // Use modalContext inside builder
              _buildQuizStartModal(modalContext, quiz), // Pass context and quiz
    );
  }

  // Separate builder function for the modal content
  Widget _buildQuizStartModal(BuildContext modalContext, Quiz quiz) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        left: 12,
        right: 12,
        top: 40,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Start Quiz',
                    style: Theme.of(modalContext).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed:
                      () => Navigator.pop(modalContext), // Use modalContext
                  tooltip: 'Close',
                ),
              ],
            ),
            const Divider(height: kVerticalSpacerLarge),

            // Quiz Title
            Text(
              quiz.title,
              style: Theme.of(
                modalContext,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: kVerticalSpacerSmall),
            // Quiz Description
            Text(
              quiz.description,
              style: Theme.of(
                modalContext,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: kVerticalSpacerMedium),

            // Quiz Info (Questions, Time)
            Row(
              children: [
                const Icon(
                  Icons.list_alt_rounded,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  '${quiz.numberOfQuestions} Questions',
                  style: Theme.of(modalContext).textTheme.bodyMedium,
                ),
                const SizedBox(width: kVerticalSpacerLarge),
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  quiz.estimatedTime,
                  style: Theme.of(modalContext).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: kVerticalSpacerLarge * 1.5),

            // Action Button
            ElevatedButton(
              onPressed: () {
                // IMPORTANT: Use the modalContext to pop
                Navigator.pop(modalContext);

                // Show snackbar using the main page's context (_QuizPageState's context)
                // No await before this, so no mounted check strictly needed *here*
                // BUT it's good practice if this action becomes async later.
                //if (!mounted) return; // Add if this becomes async
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting "${quiz.title}"... (Not Implemented Yet)',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                // --- Future Logic: Navigate to actual quiz taking screen ---
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Start Quiz Now'),
            ),
            const SizedBox(height: kVerticalSpacerSmall), // Bottom padding
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add Scaffold here for AppBar
      appBar: AppBar(title: const Text('Available Quizzes'), elevation: 1),
      body: _buildBody(), // Delegate body building
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(kPagePadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: kVerticalSpacerMedium),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: kVerticalSpacerLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: _fetchQuizzes, // Retry fetching
              ),
            ],
          ),
        ),
      );
    } else if (_quizzes.isEmpty) {
      return const Center(
        child: Text(
          'No quizzes available at the moment.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      // Display list of quizzes
      return ListView.separated(
        padding: const EdgeInsets.all(kPagePadding),
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _quizzes[index];
          return QuizCard(quiz: quiz, onTap: () => _handleSelectQuiz(quiz));
        },
        separatorBuilder:
            (context, index) => const SizedBox(height: kListItemSpacing),
      );
    }
  }
}
