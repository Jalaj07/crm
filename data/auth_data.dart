// lib/data/auth_data.dart
import 'dart:convert';
import 'package:flutter_development/models/user_model.dart'; // Adjust path
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart'; // Adjust path to your Api class definition

class AuthData {
  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(Api.login),
      body: jsonEncode({"username": username, "password": password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('token') && data['token'] != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('name', data['name'] ?? 'N/A'); // Handle potential nulls
        await prefs.setInt('user_id', data['user_id'] ?? 0);
        await prefs.setString('last_logged_in_email', username);

        // Robust handling for company_id
        if (data['company_id'] != null && data['company_id'] is List && data['company_id'].isNotEmpty) {
            final companyData = data['company_id'][0];
            if (companyData != null && companyData is Map) {
                await prefs.setInt('company_id', companyData['id'] ?? 0);
                await prefs.setString('company_name', companyData['name'] ?? 'N/A');
            } else {
                 await prefs.setInt('company_id', 0);
                 await prefs.setString('company_name', 'N/A');
            }
        } else {
            await prefs.setInt('company_id', 0);
            await prefs.setString('company_name', 'N/A');
        }
        
        return UserModel.fromJson(data);
      } else {
        throw Exception(data['message'] ?? "Login failed: Token or expected data missing in response.");
      }
    } else {
      String errorMessage = "Login failed";
      try {
        final data = jsonDecode(response.body);
        errorMessage = data['message'] ?? "Invalid response from server: ${response.statusCode}";
      } catch (_) {
        errorMessage = "Login failed. Server returned status: ${response.statusCode}. Invalid response format.";
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Optional: Get token for backend logout call if needed
    // final token = prefs.getString('token');

    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('user_id');
    await prefs.remove('company_id');
    await prefs.remove('company_name');

    // Optional: Call a backend logout endpoint if you have one
    // if (token != null && Api.logout != null) { // Assuming Api.logout is your logout URL
    //   try {
    //     await http.post(
    //       Uri.parse(Api.logout),
    //       headers: {'Authorization': 'Bearer $token'},
    //     );
    //     print("AuthData: Backend logout successful.");
    //   } catch (e) {
    //     print("AuthData: Error calling backend logout: $e. Proceeding with client-side logout.");
    //   }
    // }
   // print("AuthData: User logged out, local token cleared.");
  }

Future<UserModel> quickLogin() async {
   // print("AuthData: quickLogin() attempting...");
    await Future.delayed(const Duration(milliseconds: 700)); // Simulate network delay

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastEmail = prefs.getString('last_logged_in_email');

    if (lastEmail == null || lastEmail.isEmpty) {
      throw Exception("No last logged in user found for Quick Login.");
    }

    // --- SIMULATE SUCCESSFUL QUICK LOGIN ---
    // In a real app, you'd use the lastEmail (and potentially stored credentials or a token)
    // to authenticate against your backend.
    // For now, we'll create a dummy UserModel based on the lastEmail.

    //print("AuthData: Simulating successful quick login for $lastEmail");

    // You need to have a token and other details. For a pure simulation:
    String dummyToken = "dummy-quick-login-token-${DateTime.now().millisecondsSinceEpoch}";
    int dummyUserId = lastEmail.hashCode % 1000; // Just some dummy data
    int dummyCompanyId = 100;
    String dummyCompanyName = "QuickLogin Company";

    // Simulate saving these to prefs as if a full login happened
    await prefs.setString('token', dummyToken);
    await prefs.setString('name', lastEmail.split('@')[0]); // Use part of email as name
    await prefs.setInt('user_id', dummyUserId);
    await prefs.setInt('company_id', dummyCompanyId);
    await prefs.setString('company_name', dummyCompanyName);
    
    // Crucially, also update 'last_logged_in_email' in case it was from a different user originally.
    // However, for quick login, we typically use the *existing* 'last_logged_in_email'.

    return UserModel(
      token: dummyToken,
      userId: dummyUserId,
      name: lastEmail.split('@')[0], // Use part of email as name for demo
      companyId: dummyCompanyId,
      companyName: dummyCompanyName,
    );

    // --- To make it fail consistently (as it was before): ---
    // throw Exception("Quick Login feature not configured or failed. Please log in manually.");
  }

  Future<String> requestPasswordReset(String email) async {
 //   print("AuthData: Requesting password reset for $email");
    // --- Example using a placeholder API (replace with your actual API) ---
    // Define Api.forgotPassword in your api.dart
    // Example: static const forgotPassword = "${CommonApi.baseUrl}/authentication/forgot_password";
    // if (Api.forgotPassword == null || Api.forgotPassword.isEmpty) {
    //   throw Exception("Forgot password API endpoint not configured.");
    // }

    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    
    // Placeholder for API call:
    // final response = await http.post(
    //   Uri.parse(Api.forgotPassword), // Your actual API endpoint for password reset
    //   body: jsonEncode({"email": email}),
    //   headers: {'Content-Type': 'application/json'},
    // );

    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   print("AuthData: Password reset email sent successfully for $email.");
    //   return data['message'] ?? "Password reset instructions sent."; // Message from backend
    // } else {
    //   String errorMessage = "Failed to send password reset email";
    //    try {
    //     final data = jsonDecode(response.body);
    //     errorMessage = data['message'] ?? "Server error: ${response.statusCode}";
    //   } catch (_) {
    //      errorMessage = "Password reset failed. Server returned status: ${response.statusCode}.";
    //   }
    //   throw Exception(errorMessage);
    // }

    // --- Current Simulation ---
    if (email.isEmpty || !email.contains('@')) {
      throw Exception("Invalid email address provided for password reset.");
    }
  //  print("AuthData: (Simulated) Password reset instructions sent to $email.");
    return "If an account exists for $email, password reset instructions have been sent.";
  }
}