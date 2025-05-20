// lib/widgets/quiz_card.dart

import 'package:flutter/material.dart';
import '../../../models/hrms/courses/courses_quiz.dart';
import '../../../constants/courses_layout_constants.dart'; // Reuse constants

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const QuizCard({super.key, required this.quiz, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1.5,
      margin: EdgeInsets.zero, // Managed by ListView padding/separator
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        side: BorderSide(color: colorScheme.primary.withAlpha(51)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(kCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: kVerticalSpacerSmall),
              Text(
                quiz.description,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: kVerticalSpacerMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    context,
                    icon: Icons.question_answer_outlined,
                    label: '${quiz.numberOfQuestions} Questions',
                  ),
                  _buildInfoChip(
                    context,
                    icon: Icons.timer_outlined,
                    label: quiz.estimatedTime,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min, // Keep row tight
      children: [
        Icon(icon, size: 14, color: colorScheme.primary.withAlpha(204)),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[800]),
        ),
      ],
    );
  }
}
