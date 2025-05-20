// data/sidebar_data.dart
import 'package:flutter/material.dart';
import '../models/sidebar_item_config.dart'; // Make sure the path is correct

// --- Sidebar Structure Definition ---
final List<SidebarItemConfig> sidebarItems = [
  // --- Top Level Navigable Items ---
  const SidebarItemConfig(
    title: 'Attendance', // Corresponds to PageInfo at index 0 (hrms_home) or index 11 (hrms_timesheet)?
                         // If 'Attendance' should be 'Timesheet', navigationIndex should be 11.
                         // For now, assuming it points to index 0 (hrms_home).
    icon: Icons.access_time_rounded,
    navigationIndex: 0, // Example: if it points to the first page 'hrms_home'.
                       // If 'Attendance' is 'Timesheet', this should be 11.
    color: Color(0xFF3D5AFE),
  ),
  // --- Collapsible Sections ---
  SidebarItemConfig(
    title: 'Events',
    icon: Icons.event_outlined,
    color: Colors.purple[600],
    sectionKey: 'Events',
    children: const [
      SidebarItemConfig(
        title: 'Announced Events',
        icon: Icons.event_outlined,
        navigationIndex: 10, // Corresponds to PageInfo for 'hrms_events' (index 10)
      ),
    ],
  ),
  SidebarItemConfig(
    title: 'E-Learning',
    icon: Icons.school_outlined,
    color: Colors.blue[600],
    sectionKey: 'E-Learning',
    children: const [
      SidebarItemConfig(
        title: 'Courses',
        icon: Icons.school_rounded,
        navigationIndex: 6, // Corresponds to PageInfo for 'hrms_courses' (index 6)
      ),
    ],
  ),
  SidebarItemConfig(
    title: 'Ideation',
    icon: Icons.lightbulb_outline,
    color: Colors.amber[600],
    sectionKey: 'Ideation',
    children: const [
      SidebarItemConfig(
        title: 'My Ideas',
        icon: Icons.lightbulb_outline,
        navigationIndex: 9, // Corresponds to PageInfo for 'hrms_ideas' (index 9)
      ),
    ],
  ),
  SidebarItemConfig(
    title: 'Payroll',
    icon: Icons.paid_outlined,
    color: Colors.green[600],
    sectionKey: 'Payroll',
    children: const [
      SidebarItemConfig(
        title: 'Payslips',
        icon: Icons.account_balance_wallet_rounded,
        navigationIndex: 4, // Corresponds to PageInfo for 'hrms_payslips' (index 4)
      ),
    ],
  ),
  SidebarItemConfig(
    title: 'Resignation',
    icon: Icons.engineering_outlined,
    color: Colors.red[600],
    sectionKey: 'Resignation',
    children: const [
      SidebarItemConfig(
        title: 'Employee Resignation',
        icon: Icons.exit_to_app_rounded,
        navigationIndex: 5, // Corresponds to PageInfo for 'hrms_resignation' (index 5)
      ),
    ],
  ),
  SidebarItemConfig(
    title: 'Reimbursement',
    icon: Icons.receipt_long_outlined,
    color: Colors.orange[600],
    sectionKey: 'Reimbursement',
    children: const [
      SidebarItemConfig(
        title: 'My Expenses',
        icon: Icons.receipt_long_rounded,
        navigationIndex: 8, // Corresponds to PageInfo for 'hrms_expenses' (index 8)
      ),
    ],
  ),

  // --- Survey Section (Corrected) ---
  SidebarItemConfig(
    title: 'Survey',
    icon: Icons.poll_outlined,
    color: Colors.teal[600],
    sectionKey: 'Survey',
    children: const [
      SidebarItemConfig(
        title: 'View Surveys',
        icon: Icons.poll_outlined,
        navigationIndex: 12, // <<< CORRECTED: Was 14, now 12 (points to PageInfo for 'hrms_survey' at index 12)
      ),
    ],
  ),
  // --- End of Survey Section ---

  SidebarItemConfig(
    title: 'Travel Management',
    icon: Icons.flight_takeoff_outlined,
    color: Colors.blue[700],
    sectionKey: 'Travel Management',
    children: const [
      SidebarItemConfig(
        title: 'Travel Management',
        icon: Icons.flight_takeoff_rounded,
        navigationIndex: 7, // Corresponds to PageInfo for 'hrms_travel' (index 7)
      ),
    ],
  ),

  // --- Action Items for Help & Support and Settings are REMOVED from here ---
  // They will be added by AppModuleProvider with correct dynamic indices (13 and 14).
  // const SidebarItemConfig(
  //   title: 'Help & Support',
  //   icon: Icons.help_outline_rounded,
  //   isAction: true,
  //   navigationIndex: 11, // This was causing the problem
  //   color: Color(0xFF007BFF),
  // ),
  // const SidebarItemConfig(
  //   title: 'Settings',
  //   icon: Icons.settings_rounded,
  //   isAction: true,
  //   navigationIndex: 12, // This was causing the problem
  //   color: Color.fromARGB(255, 63, 63, 63),
  // ),
];

// --- Helper Map: Navigation Index -> Section Key (Corrected) ---
final Map<int, String> navigationIndexToSectionKey = {
  4: 'Payroll',
  5: 'Resignation',
  6: 'E-Learning',
  7: 'Travel Management',
  8: 'Reimbursement',
  9: 'Ideation',
  10: 'Events',
  12: 'Survey', // <<< CORRECTED: "View Surveys" (child of 'Survey') is at index 12
  // Indices 11 (old Help & Support) and potentially another for old Settings are removed.
  // The dynamically added H&S (index 13) and Settings (index 14) are top-level actions
  // and don't need entries here unless they are children of expandable sections,
  // which `isAction: true` items usually aren't.
};