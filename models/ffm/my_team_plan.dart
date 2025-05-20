// lib/models/my_team_plan.dart
import '../../constants/travelmanagement_filter_status.dart'; // For plan status
import './sales_entry.dart'; // Import the SalesEntry model

class MyTeamPlan {
  final String planId;
  final String planName;
  final String location;
  final String purposeOfVisit;
  final String description;
  final String? assignedTo; // Employee Name (String for simplicity, could be an Employee object)
  final String travelMode;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalDays;
  final String status; // Overall plan status
  List<SalesEntry> salesEntries; // List of sales entries

  MyTeamPlan({
    required this.planId,
    required this.planName,
    required this.location,
    required this.purposeOfVisit,
    required this.description,
    this.assignedTo,
    required this.travelMode,
    required this.fromDate,
    required this.toDate,
    required this.totalDays,
    required this.status,
    List<SalesEntry>? salesEntries, // Optional initial sales entries
  }) : salesEntries = salesEntries ?? [], // Initialize with empty list if null
       assert(toDate.isAfter(fromDate) || toDate.isAtSameMomentAs(fromDate),
            'ToDate must be after or same as FromDate');


  factory MyTeamPlan.fromMap(Map<String, dynamic> map) {
    DateTime from = map['fromDate'] is DateTime ? map['fromDate'] : DateTime.now();
    DateTime to = map['toDate'] is DateTime ? map['toDate'] : DateTime.now();
    if (to.isBefore(from)) to = from;

    List<SalesEntry> entries = [];
    if (map['salesEntries'] != null && map['salesEntries'] is List) {
      entries = (map['salesEntries'] as List)
          .map((entryMap) => SalesEntry.fromMap(entryMap as Map<String, dynamic>))
          .toList();
    }

    return MyTeamPlan(
      planId: map['planId'] ?? '',
      planName: map['planName'] ?? 'N/A',
      location: map['location'] ?? 'N/A',
      purposeOfVisit: map['purposeOfVisit'] ?? 'N/A',
      description: map['description'] ?? 'N/A',
      assignedTo: map['assignedTo'] as String?,
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
      'assignedTo': assignedTo,
      'travelMode': travelMode,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'totalDays': totalDays,
      'status': status,
      'salesEntries': salesEntries.map((entry) => entry.toMap()).toList(),
    };
  }

  // copyWith method for immutability when updating
  MyTeamPlan copyWith({
    String? planId,
    String? planName,
    String? location,
    String? purposeOfVisit,
    String? description,
    String? assignedTo, // Note: if assignedTo becomes null, use Object() to distinguish from "not set"
    String? travelMode,
    DateTime? fromDate,
    DateTime? toDate,
    int? totalDays,
    String? status,
    List<SalesEntry>? salesEntries,
  }) {
    return MyTeamPlan(
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      location: location ?? this.location,
      purposeOfVisit: purposeOfVisit ?? this.purposeOfVisit,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      travelMode: travelMode ?? this.travelMode,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      totalDays: totalDays ?? this.totalDays,
      status: status ?? this.status,
      salesEntries: salesEntries ?? this.salesEntries,
    );
  }
}