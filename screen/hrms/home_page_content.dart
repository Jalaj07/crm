// home_page_content.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// --- BLoC / Provider --- Adjust Paths if Needed ---
import 'package:flutter_development/bloc/auth/auth_bloc.dart';
// +++ ADD THIS IF YOU NEED AUTHBLOC STATE +++
import 'package:flutter_development/bloc/auth/auth_state.dart';  // +++ ADD THIS +++
// --- Data / Providers --- Adjust Paths if Needed ---
import '../../data/attendance_provider.dart';
// --- Widgets --- Adjust Paths if Needed ---
import '../../widgets/home/home_greeting_card.dart';
import '../../widgets/home/home_stats_overview.dart';
import '../../widgets/home/home_attendance_actions.dart';
// ***** FIX 2a: Make SURE this import exists and is correct *****
import '../../widgets/home/home_upcoming_events.dart'; // This file should contain the UpcomingItemData definition

// Constants
const EdgeInsets _pagePadding = EdgeInsets.all(20.0);
const SizedBox _sectionSpacing = SizedBox(height: 24.0);

class HomePageContent extends StatefulWidget {
  final VoidCallback navigateToLeave;

  const HomePageContent({super.key, required this.navigateToLeave});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d').format(now);
    final formattedTime = DateFormat('h:mm a').format(now);

    // Mock Data / Callbacks
    const String hoursToday = '6:30';
    const String leaveBalance = '12 days';
    // ***** FIX 2b: Create List using the IMPORTED UpcomingItemData *****
    final List<UpcomingItemData> upcomingItems = [
      // Make sure UpcomingItemData constructor matches the definition
      // in upcoming_events.dart
      UpcomingItemData(
        id: 1,
        title: 'Team Meeting',
        time: 'Today, 2:00 PM',
        icon: Icons.people_rounded,
        color: Colors.blue.shade600,
      ),
      UpcomingItemData(
        id: 2,
        title: 'Project Deadline',
        time: 'Tomorrow, 5:00 PM',
        icon: Icons.assignment_rounded,
        color: Colors.orange.shade700,
      ),
    ];

    // ***** FIX 3: Comment out print statements *****

    void handleUpcomingItemTap(int itemId) {
      // print("Upcoming Item $itemId Tapped"); // Commented out
      // Implement actual logic or logging later
    }

    String userName = "User"; // Default value
    final authState = context.watch<AuthBloc>().state; // Watch for changes to rebuild if needed
    if (authState is AuthSuccess) {
      userName = authState.user.name;
    } else if (authState is Authenticated) {
      // If Authenticated state is used and you don't load user data into it,
      // you might need to fetch user profile data separately or rely on SharedPreferences.
      // For simplicity, this example relies on AuthSuccess from login.
      // You could also add a listener or check prefs for 'name' if Authenticated is primary.
    }

    return SingleChildScrollView(
      padding: _pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Greeting ---
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GreetingCard(
                userName: userName,
                formattedTime: formattedTime,
                formattedDate: formattedDate,
                // ***** FIX 1: Added required currentTime *****
                currentTime: now,
              ),
            ),
          ),
          _sectionSpacing,

          // --- Stats ---
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: StatsOverview(
                hoursValue: hoursToday,
                leaveValue: leaveBalance,
              ),
            ),
          ),
          _sectionSpacing,

          // --- Attendance Actions ---
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: AttendanceActions(
                onClockInPressed: attendanceProvider.clockIn,
                onClockOutPressed: attendanceProvider.clockOut,
                onRequestLeavePressed:
                    widget.navigateToLeave, // Navigation callback
                isLoading:
                    attendanceProvider.isClockInLoading ||
                    attendanceProvider.isClockOutLoading,
                isClockedIn: attendanceProvider.isClockedIn,
                lastClockIn: attendanceProvider.lastClockIn,
                lastClockOut: attendanceProvider.lastClockOut,
              ),
            ),
          ),
          _sectionSpacing,

          // --- Upcoming ---
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: UpcomingEvents(
                // Ensure this list uses the correct UpcomingItemData type
                items: upcomingItems,

                onItemTap: handleUpcomingItemTap,
              ),
            ),
          ),
          _sectionSpacing,
        ],
      ),
    );
  }
}

// ***** FIX 2c: DELETE the duplicate class definition below IF it exists *****
/* DELETE THIS SECTION ENTIRELY if you find it in your file:
class UpcomingItemData {
  final int id;
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const UpcomingItemData({
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}
*/
