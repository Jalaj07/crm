import 'package:flutter/material.dart';
import 'package:flutter_development/constants/travelmanagement_filter_status.dart'; // Adjust path if needed

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedFilter;
  final ValueChanged<String?> onFilterChanged;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search requests (ID, Name, Purpose...)',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color?.withAlpha(127) ?? Colors.grey[600]),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surface, // Use theme color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, // Use theme color
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFilter,
                icon: const Icon(Icons.filter_list),
                // Make dropdown items more visually distinct if needed
                items:
                    FilterStatus.values.map((String filter) {
                      return DropdownMenuItem<String>(
                        value: filter,
                        child: Text(
                          filter,
                          style: TextStyle(
                            // Highlight selected?
                            // fontWeight: filter == selectedFilter ? FontWeight.bold : FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: onFilterChanged,
                style: Theme.of(context).textTheme.bodyMedium,
                dropdownColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
