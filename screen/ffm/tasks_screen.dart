import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart'; // No longer needed

// ---- IMPORTANT: Adjust this import path ----
import '../../theme/central_app_theme_color.dart'; // Placeholder for ThemeController & StatusColors

// Enum for event sorting criteria
enum EventSortCriteria {
  byTimeAsc,
  byTimeDesc,
  byTitleAsc,
  byTitleDesc,
}

// Event Model (Assuming it's defined here or imported)
class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final Color color;

  Event({
    required this.id,
    required this.title,
    this.description = '',
    this.location = '',
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
    required this.color,
  });
}

// FfmTaskScreen StatefulWidget
class FfmTaskScreen extends StatefulWidget {
  const FfmTaskScreen({super.key});

  @override
  State<FfmTaskScreen> createState() => _FfmTaskScreenState();
}

class _FfmTaskScreenState extends State<FfmTaskScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;
  final List<Event> _events = [];
  // final Uuid _uuid = const Uuid(); // No longer needed for adding events
  EventSortCriteria _currentSortCriteria = EventSortCriteria.byTimeAsc;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDates();
    // Sample events are generated in didChangeDependencies to ensure context/theme is available.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_events.where((e) => e.id.startsWith('sample-')).isEmpty) {
      _generateSampleEvents();
    }
  }

  void _generateWeekDates() {
    final DateTime now = _selectedDate;
    final int currentDayOfWeek = now.weekday;
    final DateTime monday = now.subtract(Duration(days: currentDayOfWeek - DateTime.monday));
    _weekDates = List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  void _generateSampleEvents() {
    final theme = Theme.of(context);
    final statusColors = theme.extension<StatusColors>();

    final Color defaultColorForMeeting = statusColors?.inProgress ?? theme.colorScheme.primaryContainer;
    final Color defaultColorForVisit = statusColors?.approved ?? theme.colorScheme.secondaryContainer;
    final Color defaultColorForTraining = statusColors?.pending ?? theme.colorScheme.tertiaryContainer;
    final Color defaultColorForKickoff = statusColors?.completed ?? theme.colorScheme.errorContainer;

    _populateEventsWithColors(
      defaultColorForMeeting,
      defaultColorForVisit,
      defaultColorForTraining,
      defaultColorForKickoff,
    );
  }

  void _populateEventsWithColors(Color c1, Color c2, Color c3, Color c4) {
    _events.removeWhere((e) => e.id.startsWith('sample-'));

    final DateTime basis = _selectedDate;
    // Note: The sample IDs were like 'sample-1', 'sample-2', etc.
    // These don't need a UUID if they are predefined.
    final sampleEventsData = [
      Event(
        id: 'sample-1-${basis.millisecondsSinceEpoch}', title: 'Team Strategy Meeting', // Make ID unique per generation
        description: 'Quarterly planning session for field operations.',
        location: 'Main Office, Conference Room 3',
        startTime: DateTime(basis.year, basis.month, basis.day, 9, 0),
        endTime: DateTime(basis.year, basis.month, basis.day, 11, 30),
        color: c1,
      ),
      Event(
        id: 'sample-2-${basis.millisecondsSinceEpoch}', title: 'Client Visit: Acme Corp',
        description: 'Follow-up on recent installation and gather feedback.',
        location: 'Acme Corp HQ, 123 Industrial Way',
        startTime: DateTime(basis.year, basis.month, basis.day, 14, 0),
        endTime: DateTime(basis.year, basis.month, basis.day, 15, 0),
        color: c2,
      ),
      Event(
        id: 'sample-3-${basis.millisecondsSinceEpoch}', title: 'Equipment Maintenance Training',
        description: 'Mandatory training session for all field technicians.',
        location: 'Online - Virtual Meet', isAllDay: true,
        startTime: basis.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0).add(const Duration(days:1)),
        endTime: basis.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999).add(const Duration(days:1)),
        color: c3,
      ),
      Event(
        id: 'sample-4-${basis.millisecondsSinceEpoch}', title: 'Project Alpha Kickoff',
        description: 'Initial meeting for Project Alpha with stakeholders.',
        location: 'Client Site A, Meeting Room 1',
        startTime: DateTime(basis.year, basis.month, basis.day, 11, 0),
        endTime: DateTime(basis.year, basis.month, basis.day, 12, 0),
        color: c4,
      ),
    ];
    if (mounted) {
      setState(() {
        _events.addAll(sampleEventsData);
      });
    }
  }

  void _onDateChanged(DateTime date) {
    if (mounted) {
      setState(() {
        _selectedDate = date;
        _generateWeekDates();
        // Re-generating sample events on date change IF they are meant to be dynamic for the selected week/date
        // If samples are fixed, this might not be necessary or could be handled differently.
        // For now, let's assume samples might change based on selected date context as before.
        _generateSampleEvents();
      });
    }
  }

  // void _addEvent(Event newEvent) { // No longer needed
  //   if (mounted) {
  //     setState(() {
  //       _events.add(newEvent);
  //     });
  //   }
  // }

  // Future<void> _showAddEventDialog() async { // No longer needed
  //   // ... implementation removed ...
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildWeekView(theme),
            _buildSelectedDateHeader(theme),
            Expanded(
              child: _buildEventsList(theme),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton( // REMOVED
      //   onPressed: _showAddEventDialog,
      //   backgroundColor: theme.colorScheme.primary,
      //   foregroundColor: theme.colorScheme.onPrimary,
      //   tooltip: 'Add New Event',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildWeekView(ThemeData theme) {
    final weekViewBackgroundColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final dayNameTextColor = theme.colorScheme.onSurface.withAlpha(178);
    final dateNumberTextColor = theme.colorScheme.onSurface;
    final selectedDayColor = theme.colorScheme.primary;
    final eventIndicatorColor = theme.colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: weekViewBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.light ? [
          BoxShadow(
            color: theme.shadowColor.withAlpha(25),
            blurRadius: 8, offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 22, tooltip: 'Previous week',
                  onPressed: () => _onDateChanged(_selectedDate.subtract(const Duration(days: 7))),
                  icon: Icon(Icons.chevron_left, color: theme.iconTheme.color),
                ),
                Text(
                  // Ensure _weekDates is not empty before accessing its elements
                  _weekDates.isNotEmpty 
                    ? '${DateFormat('MMMM').format(_weekDates[2])} ${_weekDates[2].year}' 
                    : '${DateFormat('MMMM').format(_selectedDate)} ${_selectedDate.year}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: dateNumberTextColor,
                  ),
                ),
                IconButton(
                  iconSize: 22, tooltip: 'Next week',
                  onPressed: () => _onDateChanged(_selectedDate.add(const Duration(days: 7))),
                  icon: Icon(Icons.chevron_right, color: theme.iconTheme.color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (_weekDates.isNotEmpty) // Guard against empty _weekDates
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _weekDates.length,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, index) {
                  final date = _weekDates[index];
                  final isSelected = DateUtils.isSameDay(date, _selectedDate);
                  
                  final hasEvents = _events.any((event) =>
                      (event.isAllDay && 
                       !date.isBefore(DateUtils.dateOnly(event.startTime)) && 
                       !date.isAfter(DateUtils.dateOnly(event.endTime))) ||
                      (!event.isAllDay && DateUtils.isSameDay(event.startTime, date)));

                  double availableWidth = MediaQuery.of(context).size.width - (2 * 12.0) - (2 * 4.0);
                  double itemWidth = (availableWidth / _weekDates.length) - (2 * 2.0);


                  return GestureDetector(
                    onTap: () => _onDateChanged(date),
                    child: Container(
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedDayColor.withAlpha(30) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? Border.all(color: selectedDayColor, width: 1.5) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(date).substring(0,1),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600, 
                              color: isSelected ? selectedDayColor : dayNameTextColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            date.day.toString(),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? selectedDayColor : dateNumberTextColor,
                            ),
                          ),
                          SizedBox(height: hasEvents ? 3: 7),
                          if (hasEvents)
                            Container(
                              width: 5, height: 5,
                              decoration: BoxDecoration(
                                color: isSelected ? selectedDayColor : eventIndicatorColor.withAlpha(153),
                                shape: BoxShape.circle,
                              ),
                            )
                          else const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
             SizedBox(height: 70, child: Center(child: Text("Loading week...", style: theme.textTheme.bodySmall))), // Fallback for week view
        ],
      ),
    );
  }

  Widget _buildSelectedDateHeader(ThemeData theme) {
    String sortCriteriaText(EventSortCriteria criteria) {
        switch (criteria) {
            case EventSortCriteria.byTimeAsc: return "Time (Asc)";
            case EventSortCriteria.byTimeDesc: return "Time (Desc)";
            case EventSortCriteria.byTitleAsc: return "Title (A-Z)";
            case EventSortCriteria.byTitleDesc: return "Title (Z-A)";
        }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              DateFormat('EEEE, MMM d').format(_selectedDate),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          PopupMenuButton<EventSortCriteria>(
            icon: Icon(Icons.sort, color: theme.iconTheme.color),
            tooltip: 'Sort events by: ${sortCriteriaText(_currentSortCriteria)}',
            onSelected: (EventSortCriteria result) {
              if (_currentSortCriteria != result && mounted) {
                setState(() => _currentSortCriteria = result);
              }
            },
            itemBuilder: (BuildContext context) => EventSortCriteria.values.map((criteria) => 
              CheckedPopupMenuItem<EventSortCriteria>(
                value: criteria,
                checked: _currentSortCriteria == criteria,
                child: Text(sortCriteriaText(criteria)),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(ThemeData theme) {
    final dateEvents = _events.where((event) {
      if (event.isAllDay) {
        final selectedDayOnly = DateUtils.dateOnly(_selectedDate);
        final eventStartDayOnly = DateUtils.dateOnly(event.startTime);
        final eventEndDayOnly = DateUtils.dateOnly(event.endTime);
        return !selectedDayOnly.isBefore(eventStartDayOnly) && !selectedDayOnly.isAfter(eventEndDayOnly);
      }
      return DateUtils.isSameDay(event.startTime, _selectedDate);
    }).toList();
    
    dateEvents.sort((a, b) {
      if (a.isAllDay && !b.isAllDay) return -1;
      if (!a.isAllDay && b.isAllDay) return 1;

      switch (_currentSortCriteria) {
        case EventSortCriteria.byTimeAsc:
          return a.startTime.compareTo(b.startTime);
        case EventSortCriteria.byTimeDesc:
          return b.startTime.compareTo(a.startTime);
        case EventSortCriteria.byTitleAsc:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case EventSortCriteria.byTitleDesc:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        }
    });

    if (dateEvents.isEmpty) {
      return _buildEmptyEventsView(theme);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Reduced bottom padding as FAB is gone
      itemCount: dateEvents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = dateEvents[index];
        return EventCard(event: event);
      },
    );
  }

  Widget _buildEmptyEventsView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined, size: 64,
              color: theme.iconTheme.color?.withAlpha(127),
            ),
            const SizedBox(height: 20),
            Text(
              'No tasks or events scheduled.', textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(178),
              ),
            ),
            const SizedBox(height: 8),
            // Removed "Tap the '+' button to add a new one." text
            // Text(
            //   "Tap the '+' button to add a new one.", textAlign: TextAlign.center,
            //   style: theme.textTheme.bodyMedium?.copyWith(
            //     color: theme.colorScheme.onSurface.withAlpha(153),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// EventCard Widget
class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: theme.cardTheme.elevation ?? (theme.brightness == Brightness.light ? 2 : 1),
      shape: theme.cardTheme.shape,
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (dialogCtx) => AlertDialog(
              backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
              title: Text(event.title, style: theme.textTheme.titleLarge?.copyWith(color: event.color, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    if (event.description.isNotEmpty) 
                      Text(event.description, style: theme.textTheme.bodyMedium?.copyWith(color: onSurfaceColor)),
                    const SizedBox(height: 10),
                    Text('Location: ${event.location.isNotEmpty ? event.location : "Not specified"}', 
                         style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceColor.withAlpha(204))),
                    const SizedBox(height: 6),
                    Text(event.isAllDay
                          ? 'All Day Event'
                          : 'Time: ${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}', 
                         style: theme.textTheme.bodySmall?.copyWith(color: onSurfaceColor.withAlpha(204))),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close', style: TextStyle(color: theme.colorScheme.primary)),
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                ),
              ],
            ),
          );
        },
        child: Row(
          children: [
            Container(width: 6, height: event.description.isNotEmpty ? 100 : 70, color: event.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: event.color, 
                      ),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          event.isAllDay ? Icons.watch_later_outlined : Icons.access_time_rounded,
                          size: 16, color: onSurfaceColor.withAlpha(153),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.isAllDay
                                ? 'All Day'
                                : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: onSurfaceColor.withAlpha(229), fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (event.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined, size: 16,
                            color: onSurfaceColor.withAlpha(153),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.location,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: onSurfaceColor.withAlpha(229), fontSize: 13.5,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurfaceColor.withAlpha(178), fontSize: 13,
                        ),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// AddEventDialog Widget and _AddEventDialogState have been completely REMOVED.