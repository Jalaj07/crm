// lib/models/tour_plan.dart
import '../../constants/travelmanagement_filter_status.dart';
import './sales_entry.dart'; // Import the SalesEntry model

class TourPlan {
  final String planId;
  final String planName;
  final String location;
  final String purposeOfVisit;
  final String description;
  // NO assignedTo FIELD HERE
  final String travelMode;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalDays;
  final String status; // Overall plan status
  List<SalesEntry> salesEntries;

  TourPlan({
    required this.planId,
    required this.planName,
    required this.location,
    required this.purposeOfVisit,
    required this.description,
    required this.travelMode,
    required this.fromDate,
    required this.toDate,
    required this.totalDays,
    required this.status,
    List<SalesEntry>? salesEntries,
  }) : salesEntries = salesEntries ?? [],
       assert(toDate.isAfter(fromDate) || toDate.isAtSameMomentAs(fromDate));

  factory TourPlan.fromMap(Map<String, dynamic> map) {
    DateTime from = map['fromDate'] is DateTime ? map['fromDate'] : DateTime.now();
    DateTime to = map['toDate'] is DateTime ? map['toDate'] : DateTime.now();
    if (to.isBefore(from)) to = from;

    List<SalesEntry> entries = [];
    if (map['salesEntries'] != null && map['salesEntries'] is List) {
      entries = (map['salesEntries'] as List)
          .map((entryMap) => SalesEntry.fromMap(entryMap as Map<String, dynamic>))
          .toList();
    }

    return TourPlan(
      planId: map['planId'] ?? '',
      planName: map['planName'] ?? 'N/A',
      location: map['location'] ?? 'N/A',
      purposeOfVisit: map['purposeOfVisit'] ?? 'N/A',
      description: map['description'] ?? 'N/A',
      travelMode: map['travelMode'] ?? 'Car',
      fromDate: from,
      toDate: to,
      totalDays: map['totalDays'] ?? (to.difference(from).inDays + 1),
      status: FilterStatus.values.contains(map['status']) ? map['status'] : FilterStatus.pending,
      salesEntries: entries,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planId': planId,
      'planName': planName,
      'location': location,
      'purposeOfVisit': purposeOfVisit,
      'description': description,
      'travelMode': travelMode,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'totalDays': totalDays,
      'status': status,
      'salesEntries': salesEntries.map((entry) => entry.toMap()).toList(),
    };
  }

  TourPlan copyWith({
    String? planId,
    String? planName,
    String? location,
    String? purposeOfVisit,
    String? description,
    String? travelMode,
    DateTime? fromDate,
    DateTime? toDate,
    int? totalDays,
    String? status,
    List<SalesEntry>? salesEntries,
  }) {
    return TourPlan(
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      location: location ?? this.location,
      purposeOfVisit: purposeOfVisit ?? this.purposeOfVisit,
      description: description ?? this.description,
      travelMode: travelMode ?? this.travelMode,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      totalDays: totalDays ?? this.totalDays,
      status: status ?? this.status,
      salesEntries: salesEntries ?? List.from(this.salesEntries),
    );
  }
}