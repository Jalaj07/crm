// models/page_info.dart
import 'package:flutter/material.dart';

class PageInfo {
  final String id;
  final String title;
  final IconData icon;
  final Widget screen;
  final bool showInBottomNav;

  const PageInfo({
    required this.id,
    required this.title,
    required this.icon,
    required this.screen,
    this.showInBottomNav = false,
  });

  // Optional: For easier comparison if used in Sets or as Map keys
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageInfo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Helper for a default/fallback PageInfo to avoid nulls
const PageInfo kErrorPageInfo = PageInfo(
  id: 'error_page_not_found',
  title: 'Error',
  icon: Icons.error_outline,
  screen: Center(child: Text("Page not found")),
  showInBottomNav: false,
);