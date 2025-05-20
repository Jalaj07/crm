import 'package:flutter/material.dart';
import 'package:flutter_development/models/hrms/announced%20events/announcedevents_event_category.dart'; // Adjust paths as needed
import 'package:flutter_development/widgets/hrms/announcedevent/announcedevents_announcement_card.dart';
import 'package:flutter_development/widgets/hrms/announcedevent/announcedevents_category_chip.dart';
import 'package:flutter_development/widgets/hrms/announcedevent/announcedevents_empty_state_widget.dart';

// Data and Models - Assuming paths are correct
import '../../../data/announcedevents_demo_data.dart';
import '../../models/hrms/announced events/announcedevents_office_announcement.dart';

class AnnouncedEventsScreen extends StatefulWidget {
  const AnnouncedEventsScreen({super.key});

  @override
  State<AnnouncedEventsScreen> createState() => _AnnouncedEventsScreenState();
}

class _AnnouncedEventsScreenState extends State<AnnouncedEventsScreen> {
  // Use the public lists from demo_data.dart
  // Create a mutable copy for state management (specifically for isSelected)
  final List<EventCategory> _categories = initialCategories
      .map((c) => EventCategory( // Create deep copy for selection state
            name: c.name,
            icon: c.icon,
            color: c.color,
            isSelected: c.isSelected,
          ))
      .toList();
  late List<OfficeAnnouncement> _filteredAnnouncements;
  String _currentCategory = 'All'; // Default category from initialCategories

  @override
  void initState() {
    super.initState();
    // Initialize with all announcements using the public demo list
    _filteredAnnouncements = List.from(demoAnnouncements);
    // Ensure the default category reflects the state
    _currentCategory = _categories.firstWhere((c) => c.isSelected).name;
  }

  void _updateCategoryFilter(String categoryName) {
    setState(() {
      _currentCategory = categoryName;
      // Update selection state
      for (var category in _categories) {
        category.isSelected = (category.name == categoryName);
      }
      // Filter announcements using the public demo list as the source
      if (categoryName == 'All') {
        _filteredAnnouncements = List.from(demoAnnouncements);
      } else {
        _filteredAnnouncements = demoAnnouncements
            .where((announcement) => announcement.category == categoryName)
            .toList();
      }
    });
  }

  // Helper to find category details (like color/icon) by name
  EventCategory _findCategoryDetails(String categoryName) {
    return _categories.firstWhere(
      (cat) => cat.name == categoryName,
      orElse: () => _categories.first, // Default to the 'All' category
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final theme = Theme.of(context); // Use if direct theme access needed
    final screenPadding = const EdgeInsets.all(16.0);

    // Use Scaffold background color from the central theme
    return Scaffold(
      // backgroundColor: theme.scaffoldBackgroundColor, // Inherited by default
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: screenPadding.copyWith(bottom: 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // --- Category Filter ---
                  _buildCategoryFilterRow(), // Uses themed chips internally
                  const SizedBox(height: 24),
                  // --- Title ---
                  Text(
                    '$_currentCategory Announcements',
                     // Use theme text style
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, // Keep weight if needed
                      // Color automatically inherited from theme's onBackground/onSurface
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            // --- Announcements List or Empty State ---
            _buildAnnouncementsSliverList(screenPadding), // Uses themed cards/empty state

            // Add padding at the very bottom if FAB might obscure content
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterRow() {
    final screenPadding = const EdgeInsets.all(16.0); // Use same padding definition
    return SizedBox(
      height: 100, // Explicit height needed for this design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        // Apply horizontal padding to the list itself to prevent chips touching screen edges
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: screenPadding.left),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            // Only apply right padding between chips now
            padding: EdgeInsets.only(right: screenPadding.right),
            child: CategoryChip( // Internally themed
              category: category,
              onTap: () => _updateCategoryFilter(category.name),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementsSliverList(EdgeInsets padding) {
    if (_filteredAnnouncements.isEmpty) {
      return SliverPadding(
        padding: padding.copyWith(top: 0),
        sliver: SliverFillRemaining(
          hasScrollBody: false,
          // EmptyStateWidget is internally themed
          child: EmptyStateWidget(categoryName: _currentCategory),
        ),
      );
    } else {
      // Apply horizontal padding here to keep cards indented
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: padding.left),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final announcement = _filteredAnnouncements[index];
            final categoryDetails = _findCategoryDetails(announcement.category);
            // Add bottom padding between cards
            return Padding(
              padding: EdgeInsets.only(bottom: padding.bottom), // Consistent bottom spacing
              child: AnnouncementCard( // Internally themed
                announcement: announcement,
                categoryColor: categoryDetails.color, // Pass color for variant backgrounds
                categoryIcon: categoryDetails.icon,
              ),
            );
          }, childCount: _filteredAnnouncements.length),
        ),
      );
    }
  }
}