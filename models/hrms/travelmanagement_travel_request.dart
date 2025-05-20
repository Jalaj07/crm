import 'package:flutter_development/constants/travelmanagement_filter_status.dart'; // Ensure this path is correct

// Represents a single travel request.
class TravelRequest {
  final String requestId;
  final String name; // e.g., Department name or requester name
  final String travelType; // e.g., Domestic, International
  final String travellerType; // e.g., Employee, Manager, Consultant
  final int totalDays;
  final String purpose;
  final String status; // Use FilterStatus constants
  final DateTime date; // Date the request was created/submitted

  TravelRequest({
    required this.requestId,
    required this.name,
    required this.travelType,
    required this.travellerType,
    required this.totalDays,
    required this.purpose,
    required this.status,
    required this.date,
  });

  // Convenience method to create an instance from a map (e.g., from JSON or database)
  // This was inferred from your initial dummy data structure.
  factory TravelRequest.fromMap(Map<String, dynamic> map) {
    return TravelRequest(
      requestId: map['requestId'] ?? '',
      name: map['name'] ?? 'N/A',
      travelType: map['travelType'] ?? 'N/A',
      travellerType: map['travellerType'] ?? 'N/A',
      totalDays: map['totalDays'] is int ? map['totalDays'] : 0,
      purpose: map['purpose'] ?? 'N/A',
      // Ensure status defaults correctly if missing or invalid
      status:
          FilterStatus.values.contains(map['status'])
              ? map['status']
              : FilterStatus.pending,
      date: map['date'] is DateTime ? map['date'] : DateTime.now(),
    );
  }

  // Optional: Method to convert back to Map (useful for saving/updating)
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'name': name,
      'travelType': travelType,
      'travellerType': travellerType,
      'totalDays': totalDays,
      'purpose': purpose,
      'status': status,
      'date': date.toIso8601String(), // Convert DateTime to string for storage
    };
  }
}
