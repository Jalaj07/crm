// lib/models/office_announcement.dart
import 'announcedevents_priority.dart'; // Import the enum

class OfficeAnnouncement {
  final String title;
  final String category; // Links to EventCategory name
  final String description;
  final DateTime date;
  final DateTime? endDate;
  final String? time;
  final String? location;
  final String createdBy;
  final String creatorAvatar;
  final bool requiresAction;
  final String? actionText;
  final Priority priority;

  OfficeAnnouncement({
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    this.endDate,
    this.time,
    this.location,
    required this.createdBy,
    required this.creatorAvatar,
    this.requiresAction = false,
    this.actionText,
    this.priority = Priority.medium,
  });
}
