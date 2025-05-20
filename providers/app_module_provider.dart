// providers/app_module_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/data/sidebar_data.dart'; // Used by HRMS
import 'package:flutter_development/models/hrms/page_info.dart';
import 'package:flutter_development/models/sidebar_item_config.dart';

// Screen imports
// HRMS Screens
import '../screen/hrms/leave_screen.dart';
import '../screen/hrms/profile_screen.dart';
import '../screen/hrms/employeeresignation_screen.dart';
import '../screen/hrms/announcedevents_screen.dart';
import '../screen/hrms/courses_card_screen.dart';
import '../screen/hrms/myIdeas_screen.dart';
import '../screen/hrms/myexpenses_screen.dart';
import '../screen/hrms/payslips_screen.dart';
import '../screen/hrms/report_screen.dart';
import '../screen/hrms/travelmanagement_screen.dart';
import '../screen/hrms/under_construction_page.dart';
import '../screen/hrms/survey_list_screen.dart';

// FFM Screens - Make sure these files exist at these paths
import '../screen/ffm/reassign_screen.dart'; // For 'reassign' page
import '../screen/ffm/reschedule_screen.dart'; // For 'reschedule' page
import '../screen/ffm/my_expenses_screen.dart'; // For 'my_expenses' page (FFM specific)
import '../screen/ffm/team_expenses_screen.dart'; // For 'team_expenses' page (FFM specific)
import '../screen/ffm/tour_plan_screen.dart'; // For 'tour_plan' page
import '../screen/ffm/my_team_plan_screen.dart'; // For 'my_team_plan' page
import '../screen/ffm/my_visits_screen.dart'; // For 'my_visits' page (Sidebar)
import '../screen/ffm/team_visits_screen.dart'; // For 'team_visits' page
import '../screen/ffm/my_schedule_screen.dart'; // For 'my_schedule' page
import '../screen/ffm/team_schedule_screen.dart'; // For 'team_schedule' page
import '../screen/ffm/visittracker_screen.dart'; // For 'map' (Visit Tracker in Bottom Nav)
import '../screen/ffm/tasks_screen.dart'; // For 'task_map' (Task in Bottom Nav) & Sidebar Reassign

// Common Screens
import '../screen/hrms/h_s_screen.dart';
import '../screen/hrms/settings_screen.dart';
import '../screen/hrms/home_page_content.dart';

// --- Common Page Definitions ---
PageInfo _commonHomePage = PageInfo(
  id: 'common_home',
  title: 'Home',
  icon: Icons.home_rounded,
  screen: HomePageContent(navigateToLeave: () {}),
  showInBottomNav: true, // Home is always in bottom nav if listed
);
const PageInfo _commonHelpPage = PageInfo(
  id: 'common_help',
  title: 'Help & Support',
  icon: Icons.help_outline_rounded,
  screen: HelpSupportScreen(),
  // showInBottomNav defaults to false if not specified in PageInfo model
);
const PageInfo _commonSettingsPage = PageInfo(
  id: 'common_settings',
  title: 'Settings',
  icon: Icons.settings_rounded,
  screen: SettingsScreen(),
  // showInBottomNav defaults to false if not specified in PageInfo model
);

// --- AppModule Enum and Extension ---
enum AppModule { hrms, crm, ffm }

extension AppModuleExtension on AppModule {
  String get displayName {
    switch (this) {
      case AppModule.hrms:
        return 'HR Management';
      case AppModule.crm:
        return 'Customer Relations';
      case AppModule.ffm:
        return 'Field Force';
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.hrms:
        return Icons.people_alt_outlined;
      case AppModule.crm:
        return Icons.business_center_outlined;
      case AppModule.ffm:
        return Icons.directions_run_outlined;
    }
  }
}

// --- Module Configuration Class ---
class ModuleConfig {
  final List<PageInfo> pages;
  final List<SidebarItemConfig> sidebarItems;
  final Map<int, String> navigationIndexToSectionKeyMap;
  final List<String> bottomNavPageIds;
  final String profilePageId;

  const ModuleConfig({
    required this.pages,
    required this.sidebarItems,
    required this.navigationIndexToSectionKeyMap,
    required this.bottomNavPageIds,
    required this.profilePageId,
  });
}

// --- AppModuleProvider Class ---
class AppModuleProvider with ChangeNotifier {
  AppModule _currentModule = AppModule.hrms;
  late Map<AppModule, ModuleConfig> _moduleConfigs;

  AppModuleProvider() {
    _moduleConfigs = {
      AppModule.hrms: _getHrmsModuleConfig(),
      AppModule.crm: _getCrmModuleConfig(),
      AppModule.ffm: _getFfmModuleConfig(),
    };
  }

  AppModule get currentModule => _currentModule;
  ModuleConfig get currentModuleConfig => _moduleConfigs[_currentModule]!;

  ModuleConfig _buildModuleConfig({
    required List<PageInfo> moduleSpecificPages,
    required List<SidebarItemConfig> moduleSpecificSidebarItems,
    required Map<int, String> moduleSpecificNavigationIndexToSectionKeyMap,
    required List<String> moduleSpecificBottomNavPageIds,
    required String moduleProfilePageId,
    bool addHelpToSidebar = true,
    bool addSettingsToSidebar = true,
  }) {
    final List<PageInfo> allPages = [
      ...moduleSpecificPages,
      _commonHelpPage,
      _commonSettingsPage,
    ];

    List<SidebarItemConfig> allSidebarItems = [...moduleSpecificSidebarItems];

    if (addHelpToSidebar) {
      allSidebarItems.add(
        SidebarItemConfig(
          title: _commonHelpPage.title,
          icon: _commonHelpPage.icon,
          navigationIndex: allPages.indexOf(_commonHelpPage),
          isAction: true,
        ),
      );
    }

    if (addSettingsToSidebar) {
      allSidebarItems.add(
        SidebarItemConfig(
          title: _commonSettingsPage.title,
          icon: _commonSettingsPage.icon,
          navigationIndex: allPages.indexOf(_commonSettingsPage),
          isAction: true,
        ),
      );
    }

    return ModuleConfig(
      pages: allPages,
      sidebarItems: allSidebarItems,
      navigationIndexToSectionKeyMap:
          moduleSpecificNavigationIndexToSectionKeyMap,
      bottomNavPageIds: moduleSpecificBottomNavPageIds,
      profilePageId: moduleProfilePageId,
    );
  }

  ModuleConfig _getHrmsModuleConfig() {
    final List<PageInfo> hrmsSpecificPages = [
      _commonHomePage, // Has showInBottomNav: true by definition
      PageInfo(
        id: 'hrms_report',
        title: 'Report',
        icon: Icons.assessment_rounded,
        screen: const EmployeeReportsScreen(),
        showInBottomNav: true,
      ),
      PageInfo(
        id: 'hrms_leave',
        title: 'Leave',
        icon: Icons.event_note_rounded,
        screen: const LeaveScreen(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_profile',
        title: 'Profile',
        icon: Icons.person_rounded,
        screen: ProfileScreen(
          navigateToLeave: () {},
          navigateToAnnouncedEvents: () {},
          navigateToTimesheet: () {},
        ),
        showInBottomNav: true,
      ),
      PageInfo(
        id: 'hrms_payslips',
        title: 'Payslips',
        icon: Icons.account_balance_wallet_rounded,
        screen: const PayslipPage(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_resignation',
        title: 'Employee Resignation',
        icon: Icons.exit_to_app_rounded,
        screen: const EmployeeResignationPage(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_courses',
        title: 'Courses',
        icon: Icons.school_rounded,
        screen: const CoursesPage(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_travel',
        title: 'Travel Management',
        icon: Icons.flight_takeoff_rounded,
        screen: const TravelManagementScreen(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_expenses',
        title: 'My Expenses',
        icon: Icons.receipt_long_rounded,
        screen: const MyExpensesScreen(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_ideas',
        title: 'My Ideas',
        icon: Icons.lightbulb_outline,
        screen: const MyIdeasScreen(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_events',
        title: 'Events',
        icon: Icons.event_outlined,
        screen: const AnnouncedEventsScreen(),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_timesheet',
        title: 'Timesheet',
        icon: Icons.schedule_outlined,
        screen: const UnderConstructionPage(featureName: 'Timesheet'),
        showInBottomNav: false,
      ),
      PageInfo(
        id: 'hrms_survey',
        title: 'View Surveys',
        icon: Icons.poll_outlined,
        screen: const SurveyListScreen(),
        showInBottomNav: false,
      ),
    ];
    return _buildModuleConfig(
      moduleSpecificPages: hrmsSpecificPages,
      moduleSpecificSidebarItems: sidebarItems, // From sidebar_data.dart
      moduleSpecificNavigationIndexToSectionKeyMap:
          navigationIndexToSectionKey, // From sidebar_data.dart
      moduleSpecificBottomNavPageIds: [
        _commonHomePage.id,
        'hrms_report',
        'hrms_profile',
      ],
      moduleProfilePageId: 'hrms_profile',
    );
  }

  ModuleConfig _getCrmModuleConfig() {
    final List<PageInfo> crmSpecificPages = [
      _commonHomePage, // Has showInBottomNav: true by definition
      PageInfo(
        id: 'crm_contacts',
        title: 'Contacts',
        icon: Icons.contacts_outlined,
        screen: const Center(child: Text("CRM Contacts")),
        showInBottomNav: true,
      ),
      PageInfo(
        id: 'crm_deals',
        title: 'Deals',
        icon: Icons.monetization_on_outlined,
        screen: const Center(child: Text("CRM Deals")),
        showInBottomNav: true,
      ),
    ];
    final List<SidebarItemConfig> crmSpecificSidebarItems = [
      SidebarItemConfig(
        title: _commonHomePage.title,
        icon: _commonHomePage.icon,
        navigationIndex: 0,
        color: Colors.blue[700],
      ),
      SidebarItemConfig(
        title: 'Client Relations',
        icon: Icons.supervisor_account_rounded,
        sectionKey: 'crm_contacts_section',
        color: Colors.green[600],
        children: const [
          SidebarItemConfig(
            title: 'Contacts',
            icon: Icons.contacts_outlined,
            navigationIndex: 1,
          ),
        ],
      ),
      SidebarItemConfig(
        title: 'Sales Pipeline',
        icon: Icons.business_center_rounded,
        sectionKey: 'crm_deals_section',
        color: Colors.orange[700],
        children: const [
          SidebarItemConfig(
            title: 'Deals',
            icon: Icons.monetization_on_outlined,
            navigationIndex: 2,
          ),
        ],
      ),
    ];
    final Map<int, String> crmNavIndexToSectionKeyMap = {
      1: 'crm_contacts_section',
      2: 'crm_deals_section',
    };
    return _buildModuleConfig(
      moduleSpecificPages: crmSpecificPages,
      moduleSpecificSidebarItems: crmSpecificSidebarItems,
      moduleSpecificNavigationIndexToSectionKeyMap: crmNavIndexToSectionKeyMap,
      moduleSpecificBottomNavPageIds: [
        _commonHomePage.id,
        'crm_contacts',
        'crm_deals',
      ],
      moduleProfilePageId: _commonSettingsPage.id,
    );
  }

  ModuleConfig _getFfmModuleConfig() {
    final List<PageInfo> ffmSpecificPages = [
      _commonHomePage, // index 0 - showInBottomNav: true from its definition
      PageInfo(
        id: 'reassign',
        title: 'Reassign Tasks',
        icon: Icons.assignment_ind_outlined,
        screen: const FfmReassignScreen(),
        showInBottomNav: false,
      ), // index 1
      PageInfo(
        id: 'reschedule',
        title: 'Reschedule Tasks',
        icon: Icons.event_repeat_outlined,
        screen: const FfmRescheduleScreen(),
        showInBottomNav: false,
      ), // index 2
      PageInfo(
        id: 'my_expenses',
        title: 'My Expenses (FFM)',
        icon: Icons.receipt_long_outlined,
        screen: const FfmMyExpensesScreen(),
        showInBottomNav: false,
      ), // index 3
      PageInfo(
        id: 'team_expenses',
        title: 'Team Expenses (FFM)',
        icon: Icons.group_work_outlined,
        screen: const FfmTeamExpensesScreen(),
        showInBottomNav: false,
      ), // index 4
      PageInfo(
        id: 'tour_plan',
        title: 'Tour Plan',
        icon: Icons.directions_bus_outlined,
        screen: const TourPlanScreen(),
        showInBottomNav: false,
      ), // index 5
      PageInfo(
        id: 'my_team_plan',
        title: 'My Team Plan',
        icon: Icons.group_add_outlined,
        screen: const MyTeamPlanScreen(),
        showInBottomNav: false,
      ), // index 6
      PageInfo(
        id: 'my_visits',
        title: 'My Visits',
        icon: Icons.person_pin_circle_outlined,
        screen: const FfmMyVisitsScreen(),
        showInBottomNav: false,
      ), // index 7
      PageInfo(
        id: 'team_visits',
        title: 'Team Visits',
        icon: Icons.groups_outlined,
        screen: const FfmTeamVisitsScreen(),
        showInBottomNav: false,
      ), // index 8
      PageInfo(
        id: 'my_schedule',
        title: 'My Visit Schedule',
        icon: Icons.calendar_today_outlined,
        screen: const FfmMyScheduleScreen(),
        showInBottomNav: false,
      ), // index 9
      PageInfo(
        id: 'team_schedule',
        title: 'Team Visit Schedule',
        icon: Icons.calendar_month_outlined,
        screen: const FfmTeamScheduleScreen(),
        showInBottomNav: false,
      ), // index 10
      PageInfo(
        id: 'map',
        title: 'Visit Tracker',
        icon: Icons.map_outlined,
        screen: const FFMVisitTrackerScreen(),
        showInBottomNav: true,
      ), // index 11 (For Bottom Nav "Visit Tracker")
      PageInfo(
        id: 'task_map',
        title: 'Task',
        icon: Icons.assignment_outlined,
        screen: const FfmTaskScreen(),
        showInBottomNav: true,
      ), // index 12 (For Bottom Nav "Task")
    ];

    final List<SidebarItemConfig> ffmSpecificSidebarItems = [
      SidebarItemConfig(
        title: _commonHomePage.title,
        icon: _commonHomePage.icon,
        navigationIndex: 0,
        color: Colors.indigo[600],
      ),
      SidebarItemConfig(
        title: 'Approvals',
        icon: Icons.rule_folder_outlined,
        sectionKey: 'approvals_section',
        color: Colors.blueGrey[600],
        children: const [
          SidebarItemConfig(
            title: 'Reassign',
            icon: Icons.assignment_ind_outlined,
            navigationIndex: 1,
          ),
          SidebarItemConfig(
            title: 'Reschedule',
            icon: Icons.event_repeat_outlined,
            navigationIndex: 2,
          ),
        ],
      ),
      SidebarItemConfig(
        title: 'Expense',
        icon: Icons.account_balance_wallet_outlined,
        sectionKey: 'expense_section',
        color: Colors.redAccent[400],
        children: const [
          SidebarItemConfig(
            title: 'My Expenses',
            icon: Icons.receipt_long_outlined,
            navigationIndex: 3,
          ),
          SidebarItemConfig(
            title: 'Team Expenses',
            icon: Icons.group_work_outlined,
            navigationIndex: 4,
          ),
        ],
      ),
      SidebarItemConfig(
        title: 'Tour Plan',
        icon: Icons.map_outlined,
        sectionKey: 'tour_plan_section',
        color: Colors.green[700],
        children: const [
          SidebarItemConfig(
            title: 'Tour Plan',
            icon: Icons.directions_bus_outlined,
            navigationIndex: 5,
          ),
          SidebarItemConfig(
            title: 'My Team Plan',
            icon: Icons.group_add_outlined,
            navigationIndex: 6,
          ),
        ],
      ),
      SidebarItemConfig(
        title: 'Visits',
        icon: Icons.location_on_outlined,
        sectionKey: 'visits_section',
        color: Colors.orange[800],
        children: const [
          SidebarItemConfig(
            title: 'My Visits',
            icon: Icons.person_pin_circle_outlined,
            navigationIndex: 7,
          ),
          SidebarItemConfig(
            title: 'Team Visits',
            icon: Icons.groups_outlined,
            navigationIndex: 8,
          ),
        ],
      ),
      SidebarItemConfig(
        title: 'Visits Schedule',
        icon: Icons.event_note_outlined,
        sectionKey: 'visits_schedule_section',
        color: Colors.purple[600],
        children: const [
          SidebarItemConfig(
            title: 'My Schedule',
            icon: Icons.calendar_today_outlined,
            navigationIndex: 9,
          ),
          SidebarItemConfig(
            title: 'Team Schedule',
            icon: Icons.calendar_month_outlined,
            navigationIndex: 10,
          ),
        ],
      ),
    ];

    final Map<int, String> ffmNavIndexToSectionKeyMap = {
      1: 'approvals_section',
      2: 'approvals_section',
      3: 'expense_section',
      4: 'expense_section',
      5: 'tour_plan_section',
      6: 'tour_plan_section',
      7: 'visits_section',
      8: 'visits_section',
      9: 'visits_schedule_section',
      10: 'visits_schedule_section',
    };

    return _buildModuleConfig(
      moduleSpecificPages: ffmSpecificPages,
      moduleSpecificSidebarItems: ffmSpecificSidebarItems,
      moduleSpecificNavigationIndexToSectionKeyMap: ffmNavIndexToSectionKeyMap,
      moduleSpecificBottomNavPageIds: [
        _commonHomePage.id,
        'task_map',
        'map',
      ], // Home, Task, Visit Tracker
      moduleProfilePageId: _commonSettingsPage.id,
    );
  }

  Future<void> selectModule(AppModule newModule) async {
    if (_currentModule != newModule) {
      _currentModule = newModule;
      notifyListeners();
    }
  }
}
