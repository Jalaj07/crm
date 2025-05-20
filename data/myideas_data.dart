import 'dart:async';
import 'package:flutter_development/constants/myideas_constants.dart';
import '../models/hrms/myideas.dart';

class IdeaService {
  // Use static list for this simulation
  static final List<Idea> _ideas = [
    Idea(
      id: '1',
      title: 'Remote Work Fridays',
      description: 'Improve work-life balance...',
      category: AppConstants.ideaCategories[1],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: AppConstants.statusUnderReview,
    ),
    Idea(
      id: '2',
      title: 'Digital Interview Process',
      description: 'Speed up hiring...',
      category: AppConstants.ideaCategories[2],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      status: AppConstants.statusApproved,
    ),
    // Add more initial ideas if needed
  ];

  Future<List<Idea>> getIdeas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate network latency
    _ideas.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    ); // Sort by newest first
    return List.unmodifiable(_ideas); // Return an unmodifiable list
  }

  Future<void> addIdea(Idea newIdea) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ideas.add(newIdea);
  }

  // Future<void> updateIdeaStatus(String id, String newStatus) async { ... }
  // Future<void> deleteIdea(String id) async { ... }
}
