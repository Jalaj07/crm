// widgets/sidebar/custom_sidebar.dart
import 'package:flutter/foundation.dart'; // For mapEquals
import 'package:flutter/material.dart';
import 'package:flutter_development/models/sidebar_item_config.dart';
import 'package:flutter_development/widgets/sidebar/sidebar_collapsible_section.dart';
import 'package:flutter_development/widgets/sidebar/sidebar_divider.dart';
import 'package:flutter_development/widgets/sidebar/sidebar_footer.dart';
import 'package:flutter_development/widgets/sidebar/sidebar_header.dart';
import 'package:flutter_development/widgets/sidebar/sidebar_menu_tile.dart';

class CustomSidebar extends StatefulWidget {
  final Function(int) onPageSelected;
  final int selectedIndex;
  final List<SidebarItemConfig> sidebarItemsConfig;
  final Map<int, String> navIndexToSectionKeyMap;

  const CustomSidebar({
    super.key,
    required this.onPageSelected,
    required this.selectedIndex,
    required this.sidebarItemsConfig,
    required this.navIndexToSectionKeyMap,
  });

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  final Map<String, bool> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    _initializeExpansionState(isInitializing: true);
  }

  @override
  void didUpdateWidget(CustomSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        !listEquals(oldWidget.sidebarItemsConfig, widget.sidebarItemsConfig) || // Use listEquals for SidebarItemConfig if defined
        !mapEquals(oldWidget.navIndexToSectionKeyMap, widget.navIndexToSectionKeyMap)) {
      _initializeExpansionState();
    }
  }

  // Helper for comparing lists (if SidebarItemConfig is not const or lacks deep equality)
  bool listEquals(List<SidebarItemConfig> a, List<SidebarItemConfig> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].title != b[i].title || a[i].navigationIndex != b[i].navigationIndex || a[i].sectionKey != b[i].sectionKey) return false;
    }
    return true;
  }

  void _initializeExpansionState({bool isInitializing = false}) {
    final String? targetSectionKeyForOpen = widget.navIndexToSectionKeyMap[widget.selectedIndex];
    final Map<String, bool> newExpandedState = {};

    for (final item in widget.sidebarItemsConfig) {
      if (item.sectionKey != null) {
        newExpandedState[item.sectionKey!] = (item.sectionKey == targetSectionKeyForOpen);
      }
    }

    if (!mapEquals(_expandedSections, newExpandedState)) {
      _expandedSections.clear();
      _expandedSections.addAll(newExpandedState);
      if (!isInitializing && mounted) { // Avoid calling setState during initState
        setState(() {});
      }
    }
  }

  List<Widget> _buildItemList(BuildContext context) {
    if (widget.sidebarItemsConfig.isEmpty) return [const Center(child: Text("No items"))];

    List<Widget> items = [];
    bool addedSeparatorForActions = false;

    for (int i = 0; i < widget.sidebarItemsConfig.length; i++) {
      final item = widget.sidebarItemsConfig[i];

      // Add a divider before action items if they appear after other types of items.
      if (item.isAction && !addedSeparatorForActions) {
          // Check if the previous item was not an action item or if it's the first item
          if (i > 0 && !widget.sidebarItemsConfig[i-1].isAction || i == 0 ) {
               // Ensure actions items don't add multiple dividers if grouped
               if (items.isNotEmpty && items.last is! SidebarDivider) { // to avoid double dividers if items are empty at first.
                 items.add(const SidebarDivider());
               }
          }
          addedSeparatorForActions = true; // Set once first action item found or separator added.
                                      // To ensure continuous actions don't each add a separator.
      } else if (!item.isAction) {
          addedSeparatorForActions = false; // Reset if we encounter a non-action item.
      }


      if (item.children != null && item.sectionKey != null) {
        final sectionKey = item.sectionKey!;
        items.add(
          SidebarCollapsibleSection(
            sectionItem: item,
            isExpanded: _expandedSections[sectionKey] ?? false,
            selectedIndex: widget.selectedIndex,
            onHeaderTap: () {
              setState(() {
                bool isCurrentlyExpanded = _expandedSections[sectionKey] ?? false;
                // Accordion behavior: close all sections
                _expandedSections.updateAll((key, value) => false);
                // If it was closed, open it. If it was open, it stays closed (due to previous line).
                if (!isCurrentlyExpanded) {
                  _expandedSections[sectionKey] = true;
                }
              });
            },
            onChildTap: widget.onPageSelected,
          ),
        );
      } else {
        items.add(
          SidebarMenuTile(
            item: item,
            isSelected: item.navigationIndex == widget.selectedIndex,
            indentLevel: 0, // Top-level items, including actions
            onTap: (item.navigationIndex != null && item.navigationIndex! >= 0)
                ? () => widget.onPageSelected(item.navigationIndex!)
                : null,
          ),
        );
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          const SidebarHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: widget.sidebarItemsConfig.isEmpty
                ? const Center(child: Text("No sidebar items"))
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: _buildItemList(context),
                  ),
          ),
          const SidebarFooter(),
        ],
      ),
    );
  }
}