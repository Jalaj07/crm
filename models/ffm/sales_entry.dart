// lib/models/sales_entry.dart
import 'package:uuid/uuid.dart';

// Example Statuses - can be shared or specific
class SalesStatus {
  static const String inProgress = 'In Progress';
  static const String approved = 'Approved';
  static const String closedWon = 'Closed (Won)';
  static const String closedLost = 'Closed (Lost)';
  static const String onHold = 'On Hold';

  static const List<String> values = [inProgress, approved, closedWon, closedLost, onHold];
}

class SalesEntry {
  final String entryId;
  final String salesNumber; // Or could be auto-generated
  final String customerName;
  final String customerAddress;
  final DateTime date;
  final String status; // e.g., "Approved", "In Progress"
  final double? amount; // Optional sales amount
  final String? notes; // Optional notes

  SalesEntry({
    String? entryId, // Allow null for new entries
    required this.salesNumber,
    required this.customerName,
    required this.customerAddress,
    required this.date,
    required this.status,
    this.amount,
    this.notes,
  }) : entryId = entryId ?? const Uuid().v4(); // Generate ID if not provided

  factory SalesEntry.fromMap(Map<String, dynamic> map) {
    return SalesEntry(
      entryId: map['entryId'],
      salesNumber: map['salesNumber'] ?? 'N/A',
      customerName: map['customerName'] ?? 'N/A',
      customerAddress: map['customerAddress'] ?? 'N/A',
      date: map['date'] is DateTime ? map['date'] : DateTime.now(),
      status: SalesStatus.values.contains(map['status']) ? map['status'] : SalesStatus.inProgress,
      amount: map['amount'] is num ? map['amount'].toDouble() : null,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'salesNumber': salesNumber,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'date': date.toIso8601String(),
      'status': status,
      'amount': amount,
      'notes': notes,
    };
  }

  //copyWith method
  SalesEntry copyWith({
    String? entryId,
    String? salesNumber,
    String? customerName,
    String? customerAddress,
    DateTime? date,
    String? status,
    double? amount,
    String? notes,
  }) {
    return SalesEntry(
      entryId: entryId ?? this.entryId,
      salesNumber: salesNumber ?? this.salesNumber,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      date: date ?? this.date,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
    );
  }
}