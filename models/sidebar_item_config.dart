import 'package:flutter/material.dart';

// --- Data Model ---
// Defines the structure for each sidebar item (navigable, section, or action)
@immutable // Marks the class as immutable, promoting good practice
class SidebarItemConfig {
  final String title; // Text displayed for the item
  final IconData icon; // Icon associated with the item
  final int?
  navigationIndex; // Index passed to onPageSelected callback (null for non-navigable items)
  final String?
  sectionKey; // Unique key to identify collapsible sections for state management
  final List<SidebarItemConfig>?
  children; // List of child items for collapsible sections
  final bool
  isAction; // Flag indicating if the item is a non-navigational action (like Settings)
  final Color? color; // Optional specific color override for the item/section

  const SidebarItemConfig({
    required this.title,
    required this.icon,
    this.navigationIndex,
    this.sectionKey,
    this.children,
    this.isAction = false,
    this.color,
  }) : assert(
         children == null || navigationIndex == null,
         'Section headers cannot have a navigation index directly.',
       ), // Validation
       assert(
         children != null || navigationIndex != null || isAction,
         'Item must be a section, navigable page, or an action.',
       ); // Validation
}
