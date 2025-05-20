// No Flutter imports needed directly for this simple model
// Use foundation.dart if properties needed `required` etc.
// import 'package:flutter/foundation.dart';

class Idea {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final String status;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.status,
  });
}
