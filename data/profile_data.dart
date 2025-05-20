// lib/services/profile_services.dart

// You might need imports if using http for real requests, e.g.:
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class ProfileData {
  // Base URL for API - replace with your actual backend URL when ready
  final String baseUrl = 'https://api.example.com';

  // Default dummy profile image URL (can be overridden by data)
  // Using a generic placeholder that doesn't require external service uptime
  static const String _defaultProfileImageUrl =
      'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250';

  // Mock function that returns dummy data matching UI expectations
  Future<Map<String, dynamic>> getProfileData() async {
    // In a real implementation, this would fetch data from an API
    // For example: return await _fetchFromApi('/api/profile');

    // Simulate network delay for realistic loading feel
    await Future.delayed(const Duration(milliseconds: 800));

    // --- Return dummy data including fields expected by ProfileScreen ---
    return {
      // Header fields
      'name': 'Anshul Sharma', //<--- ADDED
      'jobTitle': 'IT Team Lead', //<--- ADDED
      'profileImageUrl':
          _defaultProfileImageUrl, //<--- ADDED (uses static default)
      'status': 'Active', //<--- UPDATED (example status)
      // Employee Info fields (match _InfoCard keys)
      'employeeCode': 'EMP0023',
      'mobilePhone': '7945438976', //<--- UPDATED (example format)
      'workPhone': '	9765874534', //<--- UPDATED (example format)
      'workEmail': 'anshul.sha@hrmanagement.com', //<--- UPDATED (example email)
      'department': 'IT', //<--- UPDATED
      'subDepartment': 'IT', //<--- UPDATED
      // 'costCenter': 'Operational cost centers', // Not used in current UI
      'manager': 'Abhay', //<--- UPDATED (example manager)
      'hrResponsible': 'Anand', //<--- UPDATED (example HR rep)
      'businessUnit': 'Corporate', //<--- UPDATED
      'businessGroup': 'Support', //<--- UPDATED
      // Documents & Resources fields (match _StatCard keys)
      'form16': 'Available FY24-26', //<--- UPDATED (example value)
      'contracts': '1 Active', //<--- UPDATED (example value)
      'leave': '12 / 20 Days', //<--- UPDATED (example value)
      'assets': 'Laptop, Monitor', //<--- UPDATED (example value)
      'documents': 'Offer Letter', //<--- UPDATED (example value)
      // Actions & Updates fields (match _StatCard keys)
      'appraisalLetter':
          'View Letter', //<--- UPDATED (example value - assumes String now)
      'announcements': '2 Unread', //<--- UPDATED (example value)
      'timesheets':
          'Submit by Friday', //<--- UPDATED (example value - assumes String now)
      'loans': 'No Active Loans', //<--- UPDATED (example value)
    };

    // --- Example: Simulate Error ---
    // await Future.delayed(const Duration(milliseconds: 800));
    // throw Exception("Simulated API Error: Could not connect.");

    // --- Example: Simulate No Data ---
    // await Future.delayed(const Duration(milliseconds: 800));
    // return {}; // Return empty map
  }

  // This function would be used when connecting to a real backend
  /*
  Future<Map<String, dynamic>> _fetchFromApi(String endpoint) async {
    // Placeholder for getting a real token
    String? token = await _getAuthToken();
    if (token == null) {
       throw Exception('Authentication token not found.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successfully fetched data
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      // Handle unauthorized (e.g., refresh token or prompt login)
      throw Exception('Unauthorized: Please log in again.');
    } else {
      // Handle other errors
      throw Exception('Failed to load profile data (Code: ${response.statusCode}): ${response.reasonPhrase}');
    }
  }
  */

  // Example of updating profile data
  Future<bool> updateProfileData(Map<String, dynamic> updatedData) async {
    // In a real implementation, this would update data via an API POST/PUT
    /*
    String? token = await _getAuthToken();
     if (token == null) return false; // Or throw

     final response = await http.put(
       Uri.parse('$baseUrl/api/profile'), // Example endpoint
       headers: {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
       },
       body: json.encode(updatedData),
     );

     return response.statusCode == 200 || response.statusCode == 204; // Check for success codes
     */

    // For now, just simulate a successful update after a delay
    await Future.delayed(const Duration(seconds: 1));
    //print("Simulating profile update with data: $updatedData"); // Log the data locally
    return true; // Assume success
  }

  // Placeholder for retrieving auth token (implement according to your auth flow)
  /*
  Future<String?> _getAuthToken() async {
    // Implement logic to get the token from storage (e.g., flutter_secure_storage)
    // return await SecureStorageService.getToken();
    return 'YOUR_DUMMY_TOKEN_FOR_NOW'; // Replace with real logic
  }
  */
}
