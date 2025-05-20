// lib/models/quiz.dart

class Quiz {
  final String id;
  final String title;
  final String description;
  final int numberOfQuestions;
  final String estimatedTime; // e.g., "5 min", "10 questions"

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfQuestions,
    required this.estimatedTime,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id']?.toString() ?? 'unknown_quiz_id',
      title: json['title'] as String? ?? 'Unnamed Quiz',
      description:
          json['description'] as String? ?? 'No description available.',
      numberOfQuestions:
          json['numberOfQuestions'] is int
              ? json['numberOfQuestions']
              : int.tryParse(json['numberOfQuestions']?.toString() ?? '0') ?? 0,
      estimatedTime: json['estimatedTime'] as String? ?? '~',
    );
  }
}
