import 'package:flutter/material.dart';
import 'package:flutter_development/theme/central_app_theme_color.dart';
import '../main_navigation_screen.dart'; // Import the MainNavigationScreen
import 'courses_card_screen.dart'; // Import other screens for routes
import 'payslips_screen.dart';
import 'employeeresignation_screen.dart';
import 'travelmanagement_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GainHub",
      debugShowCheckedModeBanner: false,
      theme: ThemeController.lightTheme,
      darkTheme: ThemeController.darkTheme,
      themeMode: ThemeMode.system,
      home:
          const MainNavigationScreen(), // Set MainNavigationScreen as the home
      routes: {
        // Define routes here if you still need named routes for direct navigation
        '/courses_route': (context) => const CoursesPage(),
        '/payslips_route': (context) => const PayslipPage(),
        '/employee_resignation_route':
            (context) => const EmployeeResignationPage(),
        '/travel_management_route': (context) => const TravelManagementScreen(),
      },
    );
  }
}

// The MainNavigationScreen and HomePageContent widgets should NOT be in this file anymore.
// They will be in their own files.
