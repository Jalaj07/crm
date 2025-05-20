import 'package:flutter/material.dart';
import '../../constants/profile/profile_constants.dart';
import 'profile_section_title.dart';
import 'profile_stat_card.dart';

typedef StatItemTapCallback = void Function(String title, String value);

// Generic builder method for sections that display a list of StatCard widgets
class ProfileGenericStatSection extends StatelessWidget {
  final String sectionTitle;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> userData;
  final StatItemTapCallback onItemTap;

  const ProfileGenericStatSection({
    required this.sectionTitle,
    required this.items,
    required this.userData,
    required this.onItemTap,
    super.key,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(sectionTitle), // Use imported widget
        // Generate the list of _StatCard widgets from the items map
        ...items.map((item) {
          final value = _getStringValue(item['key']);
          return StatCard(
            icon: item['icon'],
            title: item['title'],
            value: value,
            iconColor: item['color'],
            onTap:
                () =>
                    onItemTap(item['title'], value), // Use the passed callback
          );
        }),
      ],
    );
  }
}
