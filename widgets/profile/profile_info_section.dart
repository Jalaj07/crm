import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';
import 'profile_section_title.dart';
import 'profile_info_card.dart';

typedef InfoItemTapCallback = void Function(String title, String value);

// Builds the section containing multiple info cards in rows
class ProfileInfoSection extends StatelessWidget {
  final Map<String, dynamic> userData;
  final InfoItemTapCallback onItemTap;

  const ProfileInfoSection({
    required this.userData,
    required this.onItemTap,
    super.key,
  });

  // Keep item definitions specific to this section
  static const List<Map<String, String>> _items = [
    {'title': 'Employee Code', 'key': 'employeeCode'},
    {'title': 'Department', 'key': 'department'},
    {'title': 'Mobile Phone', 'key': 'mobilePhone'},
    {'title': 'Sub Department', 'key': 'subDepartment'},
    {'title': 'Work Phone', 'key': 'workPhone'},
    {'title': 'Work Email', 'key': 'workEmail'},
    {'title': 'Manager', 'key': 'manager'},
    {'title': 'Business Group', 'key': 'businessGroup'},
    {'title': 'HR Responsible', 'key': 'hrResponsible'},
    {'title': 'Business Unit', 'key': 'businessUnit'},
  ];

  // Helper moved here, specific to how this section processes data
  String _getStringValue(String key, {String defaultValue = kNotAvailable}) {
    final value = userData[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      return defaultValue;
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Build rows of two items programmatically
    List<Widget> rows = [];
    for (int i = 0; i < _items.length; i += 2) {
      final item1 = _items[i];
      final value1 = _getStringValue(item1['key']!);
      final card1 = InfoCard(
        title: item1['title']!,
        value: value1,
        onTap: () => onItemTap(item1['title']!, value1),
      );

      Widget card2; // Placeholder for the second card in the row
      if (i + 1 < _items.length) {
        // If there's a second item for this row
        final item2 = _items[i + 1];
        final value2 = _getStringValue(item2['key']!);
        card2 = InfoCard(
          title: item2['title']!,
          value: value2,
          onTap: () => onItemTap(item2['title']!, value2),
        );
      } else {
        // If odd number of items, fill the space with an empty expanded widget
        card2 = const Expanded(child: SizedBox.shrink());
      }
      // Add the row containing the two cards (or card + placeholder)
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [card1, card2],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Employee Information'), // Use the imported widget
        Padding(
          // Add horizontal padding to the container of the rows
          padding: const EdgeInsets.symmetric(
            horizontal: kSectionPaddingHorizontal - (kCardMargin / 2),
          ), // Align inner cards
          child: Column(children: rows), // Place generated rows inside a Column
        ),
      ],
    );
  }
}
