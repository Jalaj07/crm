// lib/data/demo_data.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/models/hrms/announced%20events/announcedevents_event_category.dart';
import 'package:flutter_development/models/hrms/announced%20events/announcedevents_priority.dart';
import '../models/hrms/announced events/announcedevents_office_announcement.dart';

// Note: Removed leading underscores '_' to make them publicly accessible
// within the library (package).

final List<EventCategory> initialCategories = [
  EventCategory(
    name: 'All',
    icon: Icons.wysiwyg,
    color: Colors.blueGrey,
    isSelected: true,
  ),
  EventCategory(name: 'Meetings', icon: Icons.people, color: Colors.blue),
  EventCategory(name: 'Deadlines', icon: Icons.timer, color: Colors.red),
  EventCategory(name: 'Company', icon: Icons.business, color: Colors.purple),
  EventCategory(name: 'Training', icon: Icons.school, color: Colors.orange),
];

final List<OfficeAnnouncement> demoAnnouncements = [
  OfficeAnnouncement(
    title: 'Quarterly Planning Meeting',
    category: 'Meetings',
    description:
        'All department heads are required to attend the Q2 planning meeting. Please prepare your quarterly reports and budget proposals for the next fiscal quarter.',
    date: DateTime.now().add(const Duration(days: 5)),
    time: '10:00 AM - 12:00 PM',
    location: 'Conference Room A, 3rd Floor',
    createdBy: 'Sarah Johnson',
    creatorAvatar: 'https://randomuser.me/api/portraits/women/44.jpg',
    requiresAction: true,
    actionText: 'RSVP',
    priority: Priority.high,
  ),
  OfficeAnnouncement(
    title: 'Project Milestone Deadline',
    category: 'Deadlines',
    description:
        'This is a reminder that all deliverables for the Phoenix Project Phase 1 are due by end of day this Friday. Please ensure your tasks are completed in the project management system.',
    date: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'Michael Chen',
    creatorAvatar: 'https://randomuser.me/api/portraits/men/32.jpg',
    requiresAction: false,
    priority: Priority.medium,
  ),
  OfficeAnnouncement(
    title: 'Company Anniversary Celebration',
    category: 'Company',
    description:
        'Join us in celebrating our company\'s 10th anniversary! There will be food, drinks, and activities for all employees. Family members are welcome to join.',
    date: DateTime.now().add(const Duration(days: 15)),
    time: '3:00 PM - 7:00 PM',
    location: 'Company Courtyard',
    createdBy: 'HR Department',
    creatorAvatar: 'https://randomuser.me/api/portraits/women/68.jpg',
    requiresAction: true,
    actionText: 'RSVP',
    priority: Priority.low,
  ),
  OfficeAnnouncement(
    title: 'New Software Training',
    category: 'Training',
    description:
        'Mandatory training session for the new CRM software. All sales and customer service representatives must attend. The session will cover basic functionality and common workflows.',
    date: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 8)),
    time: '1:00 PM - 3:00 PM',
    location: 'Training Room B, 2nd Floor',
    createdBy: 'IT Department',
    creatorAvatar: 'https://randomuser.me/api/portraits/men/75.jpg',
    requiresAction: true,
    actionText: 'Confirm Attendance',
    priority: Priority.medium,
  ),
  OfficeAnnouncement(
    title: 'Office Closure - Memorial Day',
    category: 'Company',
    description:
        'The office will be closed on Monday, May 27th in observance of Memorial Day. Regular operations will resume on Tuesday, May 28th.',
    date: DateTime.now().add(
      const Duration(days: 30),
    ), // Example date far in future
    createdBy: 'Office Management',
    creatorAvatar: 'https://randomuser.me/api/portraits/women/90.jpg',
    requiresAction: false,
    priority: Priority.low,
  ),
];
