// lib/data/dummy_travel_requests.dart
import '../constants/travelmanagement_filter_status.dart'; // Adjust path
import '../models/hrms/travelmanagement_travel_request.dart';  // Adjust path

List<TravelRequest> getDummyTravelRequests() {
  return [
    TravelRequest.fromMap({
      'requestId': 'TR00009',
      'name': 'HR Department',
      'travelType': 'Domestic',
      'travellerType': 'Employee',
      'totalDays': 1,
      'purpose': 'Attend HR Seminar in City B',
      'status': FilterStatus.approved,
      'date': DateTime.now().subtract(const Duration(days: 2)),
    }),
    TravelRequest.fromMap({
      'requestId': 'TR00007',
      'name': 'Jane Doe (Sales)',
      'travelType': 'Domestic',
      'travellerType': 'Manager',
      'totalDays': 8,
      'purpose': 'Client Visit Cycle - West Region',
      'status': FilterStatus.pending,
      'date': DateTime.now().subtract(const Duration(days: 5)),
    }),
    TravelRequest.fromMap({
      'requestId': 'TR00015',
      'name': 'Marketing Team',
      'travelType': 'International',
      'travellerType': 'Team',
      'totalDays': 5,
      'purpose': 'Global Marketing Conference 2024 - Berlin',
      'status': FilterStatus.inProgress,
      'date': DateTime.now().subtract(const Duration(days: 1)),
    }),
    TravelRequest.fromMap({
      'requestId': 'TR00023',
      'name': 'Sales Lead (East)',
      'travelType': 'Domestic',
      'travellerType': 'Employee',
      'totalDays': 3,
      'purpose': 'Finalize Deal with ACME Corp',
      'status': FilterStatus.completed,
      'date': DateTime.now().subtract(const Duration(days: 10)),
    }),
    TravelRequest.fromMap({
      'requestId': 'TR00031',
      'name': 'Tech Support',
      'travelType': 'Domestic',
      'travellerType': 'Specialist',
      'totalDays': 2,
      'purpose': 'On-site Server Maintenance - Client XYZ',
      'status': FilterStatus.pending,
      'date': DateTime.now().subtract(const Duration(days: 3)),
    }),
    // ... other requests
  ];
}