// lib/models/event_category.dart
import 'package:flutter/material.dart';

class EventCategory {
  final String name;
  final IconData icon;
  final Color color;
  bool isSelected;

  EventCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.isSelected = false,
  });
}
